-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				staged = { text = "!" },
			},
			_signs_staged_enable = true,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Inside hunk" })
				vim.keymap.set("n", "<leader>wc", function()
					gs.setqflist("all", { open = false })
					vim.cmd("cclose")
					vim.cmd("Telescope quickfix")
				end)
				-- stylua: ignore start
				vim.keymap.set("n", "gk", function() gs.next_hunk() end, { desc = "Next hunk" })
				vim.keymap.set("n", "gi", function() gs.prev_hunk() end, { desc = "Prev hunk" })
				vim.keymap.set("n", "gO", function() gs.diffthis() end, { desc = "File preview"} )
				vim.keymap.set("n", "go", function() gs.preview_hunk() end,  { desc = "Hunk preview" } )

				vim.keymap.set("n", "gU", function() gs.reset_buffer() end, { desc = "Reset buffer" } )

				vim.keymap.set("n", "gu", function() gs.reset_hunk() end, { desc = "Reset hunk" } )
				vim.keymap.set("v", "gu", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset lines" } )

				vim.keymap.set("n", "gs", function() gs.stage_hunk() end, { desc = "Stage hunk" } )
				vim.keymap.set("v", "gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" } )

				vim.keymap.set("n", "gS", function() gs.undo_stage_hunk() end, { desc = "Unstage hunk" } )
				vim.keymap.set("v", "gS", function() gs.undo_stage_hunk( vim.fn.line("."), vim.fn.line("v") ) end, { desc = "Unstage hunk" } )
			end,
		},
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local actions = require("diffview.actions")
			require("diffview").setup({
		-- stylua: ignore start
				keymaps = {
					disable_defaults = true,
					file_panel = {
						{ "n", "<leader>wp", actions.toggle_files, { desc = "Toggle the file panel" } },

						{ "n", "gp", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
						{ "n", "gP", actions.stage_all, { desc = "Stage all entries" } },

						{ "n", "gU", actions.restore_entry, { desc = "Restore entry to the state on the left side" } },

						{ "n", "k", actions.next_entry, { desc = "Bring the cursor to the next file entry" }, },
						{ "n", "i", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
						{ "n", "<up>", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
						{ "n", "<down>", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
						{ "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
						{ "n", "l", actions.select_entry, { desc = "Open the diff for the selected entry" } },

						{ "n", "<tab>", actions.toggle_fold, { desc = "Toggle fold" } },
						{ "n", ">", actions.open_fold, { desc = "Expand fold" } },
						{ "n", "<", actions.close_fold, { desc = "Collapse fold" } },
						{ "n", "≥", actions.open_all_folds, { desc = "Expand all folds" } },
						{ "n", "≤", actions.close_all_folds, { desc = "Collapse all folds" } },
					},

					diff2 = {
						{ "n", "<leader>wp", actions.toggle_files, { desc = "Toggle the file panel" } },
						{ "n", "zi", function() vim.cmd("normal! zb") end   },


						{ "n" , "gk", function() vim.cmd("normal! ]c") end, {desc= "Next hunk"}},
						{ "n" , "gi", function() vim.cmd("normal! [c") end, {desc= "Prev hunk"}},
						{ "n", "gh", actions.prev_conflict, { desc = "Go to the previous conflict" } },
						{ "n", "gç", actions.next_conflict, { desc = "Go to the next conflict" } },

						{ "n", "gK", actions.select_next_entry, { desc = "Open the diff for the next file" } },
						{ "n", "gI", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },


						{ "n", "gmo", actions.conflict_choose_all("ours"), { desc = "Choose the OURS version of a conflict for the whole file" }, },
						{ "n", "gmt", actions.conflict_choose_all("theirs"), { desc = "Choose the THEIRS version of a conflict for the whole file" }, },
						{ "n", "gmb", actions.conflict_choose_all("base"), { desc = "Choose the BASE version of a conflict for the whole file" }, },
						{ "n", "gma", actions.conflict_choose_all("all"), { desc = "Choose all the versions of a conflict for the whole file" }, },
						{ "n", "gmd", actions.conflict_choose_all("none"), { desc = "Delete the conflict region for the whole file" }, },

					},

					view = {
						{ "n", "<leader>wp", actions.toggle_files, { desc = "Toggle the file panel" } },
						{ "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },
						{ "n", "gl", actions.open_commit_log, { desc = "Open the commit log panel" } },
						{ "n", "gL", actions.cycle_layout, { desc = "Cycle available layouts" } },
					},
				},
				-- stylua: ignore end
			})

			vim.keymap.set("n", "<leader>wg", function()
				if next(require("diffview.lib").views) == nil then
					vim.cmd("DiffviewOpen")
					actions.toggle_files()
				else
					vim.cmd("DiffviewClose")
				end
			end)
		end,
	},
}
-- vim: ts=4 sts=4 sw=4
