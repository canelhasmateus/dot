vim.cmd [[
  augroup packer_user_config_2
    autocmd!
    autocmd BufWritePost keymaps.lua source <afile> 
    augroup end
]]

local function snoremap(mode, press, action)

  vim.keymap.set(mode, press, action)
  --vim.api.nvim_set_keymap(mode, press, action, { noremap = true, silent = false })
end

local function anoremap(press, action)
    snoremap("", press, action)
end

local function nnoremap(press, action)
    snoremap("n", press, action)
end

local function vnoremap(press, action)
    snoremap("v", press, action)
end

local function inoremap(press, action)
    snoremap("i", press, action)
end

----------------------------------------------------------------------------------------------------

anoremap("<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "
----------------------------------------------------------------------------------------------------

-- Prevents windows ctrl + z bug.
anoremap("<C-z>", "u")
inoremap("<C-z>", "<ESC>:undo<CR>i")

nnoremap("<S-<ESC>>", "<Esc>")
nnoremap("<A-w>p", ":NERDTreeToggle<CR>")
nnoremap("<A-w><A-p>", ":NERDTreeFind<CR>")
vnoremap("el", "<Esc>`>a")
vnoremap("ej", "<Esc>`<i")
nnoremap("eo", "%a")
vnoremap("eo", "<Esc>%a")
nnoremap("fl", ":HopWordAC<CR>")
nnoremap("fj", ":HopWordBC<CR>")
vnoremap("fj", ":<C-u>HopWordBC<CR>")
vnoremap("fl", ":<C-u>HopWordAC<CR>")

inoremap("<C-BS>", "<Esc>dbi")
inoremap("<C-Del>", "<Esc>dwi")

