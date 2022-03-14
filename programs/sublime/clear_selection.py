import sublime_plugin


class ClearSelectionsCommand(sublime_plugin.TextCommand):

	def run(self, edit):
		"""Clear all selelections and keep carets."""
		sel = self.view.sel()
		if sel:
			carets = [s.b for s in sel]
			sel.clear()
			for caret in carets:
				sel.add(caret)