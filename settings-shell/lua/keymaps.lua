vim.keymap.set("i", "<C-H>", "<C-w>")
vim.keymap.set("i", "<F6>", "<Esc>dwi")

vim.keymap.set("n", "<C-a>", ":%y<CR>")
vim.keymap.set("n", "<leader>w,", "<C-W><C-O>")
vim.keymap.set("n", "<leader>wr", function()
	vim.cmd("source ~/.config/nvim/vimrc")
	vim.cmd("source ~/.config/nvim/lua/keymaps.lua")
end)

vim.keymap.set("n", "zl", "<C-W><Right>")
vim.keymap.set("n", "zj", "<C-W><Left>")
vim.keymap.set("n", "zL", "zo")
vim.keymap.set("n", "zJ", "zc")

vim.keymap.set({ "n", "x" }, "nF", "gf")
vim.keymap.set({ "n", "x" }, "rj", "J")

vim.keymap.set("n", "<leader>wg", function()
	vim.cmd(":Neogit cwd=%:p:h")
end)

vim.keymap.set("n", "<leader>wt", "<cmd>terminal<cr>", { desc = "open terminal" })
vim.keymap.set("n", "<leader>wl", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic keymaps
vim.keymap.set("n", "qh", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "qç", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "qw", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "oq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

print("Reloaded")
