 import static liveplugin.PluginUtil.*

import com.intellij.codeInsight.folding.impl.EditorFoldingInfo
import com.intellij.codeInsight.folding.impl.FoldingUtil
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.editor.Document
import com.intellij.openapi.editor.Editor
import com.intellij.openapi.editor.FoldRegion
import com.intellij.openapi.editor.ex.FoldingModelEx

import java.util.regex.Pattern

import static liveplugin.PluginUtil.*

// This is a micro-plugin to collapse Java keywords into shorter symbols.
// (looks better if folded text background is the same as normal text; Settings -> Editor -> Colors & Fonts)
// (Note that it can only be executed within this plugin https://github.com/dkandalov/live-plugin)

registerAction("symbolizeKeyWords", "ctrl alt shift 0") { AnActionEvent event ->
    def editor = currentEditorIn(event.project)
    collapseIn(editor, "(@Override\n?\\s+)\\s", { "↑" })
    collapseIn(editor, "(public\n?\\s*?)\\s", { "●" })
    collapseIn(editor, "(private\n?\\s*?)\\s", { "○" })
    collapseIn(editor, "(protected\n?\\s*?)\\s", { "□" })
    collapseIn(editor, "(static\n?\\s*?)\\s", { "◆" })
    collapseIn(editor, "(final\n?\\s*?)\\s", { "ƒ" })
    collapseIn(editor, "( extends )", { " ← " })
    collapseIn(editor, "( implements )", { " ⇠ " })
    collapseIn(editor, "\\S(.;\n)", { it.replace(";", "") })
    collapseIn(editor, "(\\(\\))", { "" })
    collapseIn(editor, "(!=)", { "≠" })
    collapseIn(editor, "(return)", { "↵" })

    // replace "." with "->" if you really miss C++
    //collapseIn(editor, "(\\S\\.)", { it.replace(".", "->") })
}
if (!isIdeStartup) show("Loaded symbolizeKeywords action. Use Ctrl+Alt+Shift+0 to run it.")


def collapseIn(Editor editor, String regExp, Closure replacementFor) {
    def matches = []
    def matcher = Pattern.compile(regExp).matcher(editor.document.charsSequence)
    while (matcher.find()) {
        matches << [start: matcher.start(1), end: matcher.end(1), text: matcher.group(1)]
    }

    editor.foldingModel.runBatchFoldingOperation(new Runnable() {
        @Override
        public void run() {
            matches.each { foldText(it.start, it.end, replacementFor(it.text), editor) }
        }
    })
}

/**
 * Originally copied from com.intellij.codeInsight.folding.impl.CollapseSelectionHandler
 */
def foldText(int start, int end, String placeHolderText, Editor editor) {
    if (start + 1 >= end) return
    if (start < end && editor.document.charsSequence.charAt(end - 1) == '\n') end--

    FoldRegion region = FoldingUtil.findFoldRegion(editor, start, end)
    if (region != null) {
        EditorFoldingInfo info = EditorFoldingInfo.get(editor)
        if (info.getPsiElement(region) == null) {
            editor.foldingModel.removeFoldRegion(region)
            info.removeRegion(region)
        }
    } else {
        region = ((FoldingModelEx)editor.foldingModel).addFoldRegion(start, end, placeHolderText)
        if (region == null) {
            return
        }
        region.expanded = false
    }
}