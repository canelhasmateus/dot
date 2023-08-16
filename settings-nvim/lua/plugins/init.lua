local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  
  use 'phaazon/hop.nvim'
  use 'akinsho/toggleterm.nvim'
  use 'nvim-treesitter/nvim-treesitter'

  use {
     'nvim-telescope/telescope.nvim', 
      tag = '0.1.2',
      requires = { {'nvim-lua/plenary.nvim'} } }
  use 'nvim-telescope/telescope-project.nvim' 
  use 'nvim-lua/plenary.nvim'
  use {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('hop').setup {
  uppercase_labels = true,
}

require("toggleterm").setup{
  open_mapping = "<A-w>t"
}

require('telescope').setup { }

-- empty setup using defaults
-- require("nvim-tree").setup({
--   sort_by = "case_sensitive",
--   view = {
--     adaptive_size = true,
--     mappings = {
--       -- custom_only = true,
--       list = {

--         { key = '<BS>', action = 'close_node' },
--         { key = 'j', action = 'close_node' },
--         { key = '<Left>', action = 'close_node' },
        
--         { key = '<', action = 'parent_node' },
--         { key = '>', action = 'next_sibling' },
--         { key = '<Home>', action = 'first_sibling' },
--         { key = '<End>', action = 'last_sibling' },
--         { key = '<C-]>', action = 'cd' },
--         { key = 'R', action = 'refresh' },
--         { key = 'a', action = 'create' },
--         { key = 'rn', action = 'rename' },
--         { key = '-', action = '' },
--         { key = '/', action = 'live_filter' },
--         { key = '?', action = 'clear_live_filter' },
--         { key = 'f', action = 'search_node' },
--         { key = '<CR>', action =             'edit'},                
--         { key = '<Space>', action =             'edit'},                
--         { key = "l", action = "edit" },
--         { key = "<Right>", action = "edit" },
--         { key = '<Esc>', action =             'close'},                
--       },
--     },
--   },
--   renderer = {
--     group_empty = true,
--   },
-- })


-- require'nvim-treesitter.configs'.setup {
--   highlight = {
--     enable = true,
--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = false,
--   },
-- }

