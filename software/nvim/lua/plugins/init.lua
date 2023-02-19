local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
}
print "Installing packer close and reopen Neovim..."
vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return 
end

-- Have packer use a popup window
packer.init {
display = {
    open_fn = function()
    return require("packer.util").float { border = "rounded" }
    end,
},
}


if PACKER_BOOTSTRAP then
    packer.colour()
end

require('hop').setup {
  uppercase_labels = true,
}

-- empty setup using defaults
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      -- custom_only = true,
      list = {

        { key = '<BS>', action = 'close_node' },
        { key = 'j', action = 'close_node' },
        { key = '<Left>', action = 'close_node' },
        
        { key = '<', action = 'parent_node' },
        { key = '>', action = 'next_sibling' },
        { key = '<Home>', action = 'first_sibling' },
        { key = '<End>', action = 'last_sibling' },
        { key = '<C-]>', action = 'cd' },
        { key = 'R', action = 'refresh' },
        { key = 'a', action = 'create' },
        { key = 'rn', action = 'rename' },
        { key = '-', action = '' },
        { key = '/', action = 'live_filter' },
        { key = '?', action = 'clear_live_filter' },
        { key = 'f', action = 'search_node' },
        { key = '<CR>', action =             'edit'},                
        { key = '<Space>', action =             'edit'},                
        { key = "l", action = "edit" },
        { key = "<Right>", action = "edit" },
        { key = '<Esc>', action =             'close'},                
      },
    },
  },
  renderer = {
    group_empty = true,
  },
})

require("toggleterm").setup{
  open_mapping = "<A-w>t"
}

require('telescope').setup {
  extensions = {
    project = {

      hidden_files = true, -- default: false
      theme = "dropdown",
      order_by = "asc",
      search_by = "title",
      sync_with_nvim_tree = true, -- default false
    }
  }
}
require'telescope'.load_extension('project')

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

