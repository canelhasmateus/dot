import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.internal.psiView.PsiViewerDialog

import static liveplugin.PluginUtil.*

registerAction("Show Psi Viewer Dialog for Current File", "ctrl shift P") { AnActionEvent e->
    // IntelliJ way
    //def editor = com.intellij.openapi.actionSystem.CommonDataKeys.EDITOR.getData(e.getDataContext())
    // live-plugin way
    new PsiViewerDialog(project, currentEditorIn(e.project)).show()
}