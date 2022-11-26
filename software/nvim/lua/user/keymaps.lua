local function snoremap(mode, press, action)
    vim.api.nvim_set_keymap(mode, press, action, { noremap = true, silent = false })
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