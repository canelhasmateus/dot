import sublime
import sublime_plugin

class PartialPagerCommand(sublime_plugin.TextCommand):
	def run(self, edit, amount):

		view = self.view
		rowcnt = float(view.rowcol(view.visible_region().end())[0] -
		               view.rowcol(view.visible_region().begin())[0])
		movecnt = round(rowcnt * amount)

		rowcol = view.rowcol(view.sel()[0].begin())
		line = rowcol[0] + movecnt
		col = rowcol[1]

		pt = view.text_point(line, col)
		view.sel().clear()
		view.sel().add(sublime.Region(pt))
		view.show_at_center(pt)