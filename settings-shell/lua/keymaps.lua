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

vim.keymap.set("n", "<leader>wg", function()
	vim.cmd(":Neogit cwd=%:p:h")
end)

print("Reloaded")
