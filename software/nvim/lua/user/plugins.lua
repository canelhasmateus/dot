local function packer_setup(plugins)

  local fn = vim.fn

  -- Automatically install packer
  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
      "<Space>git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
  end

  -- Autocommand that reloads neovim whenever you save the plugins.lua file
  vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
    
    augroup end
]]

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



  packer.startup(function(use)
    for _, plugin in pairs(plugins) do
      use(plugin)
    end

  end)

  if PACKER_BOOTSTRAP then
    packer.sync()
  end

end

local function plugins()
  return {
    "wbthomason/packer.nvim" -- Have packer manage itself

    , "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    , "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    
    , "nvim-tree/nvim-web-devicons"
    , "nvim-tree/nvim-tree.lua"
    , "akinsho/toggleterm.nvim"

    -- The ones from IJ
    , "phaazon/hop.nvim"
    , "tpope/vim-surround"
    , "dbakker/vim-paragraph-motion"
    , "chrisbra/matchit"
    , "tommcdo/vim-exchange"
    , "machakann/vim-highlightedyank"
    , "michaeljsmith/vim-indent-object"
    , "mg979/vim-visual-multi"


    -- Colorschemes
    , "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
    , 'folke/tokyonight.nvim' -- A bunch of colorschemes you can try out
    --use "lunarvim/darkplus.nvim"

    -- cmp plugins
    , "hrsh7th/nvim-cmp" -- The completion plugin
    , "hrsh7th/cmp-buffer" -- buffer completions
    , "hrsh7th/cmp-path" -- path completions
    , "hrsh7th/cmp-cmdline" -- cmdline completions
    , "saadparwaiz1/cmp_luasnip" -- snippet completions
    , "hrsh7th/cmp-nvim-lsp" -- cmdline completions
    -- snippets
    , "L3MON4D3/LuaSnip" --snippet engine
    , "rafamadriz/friendly-snippets" -- a bunch of snippets to use  -- snippets


    , "neovim/nvim-lspconfig" -- basic lsp configs
    , "williamboman/mason.nvim" -- replacement for lsp-installer
    , 'williamboman/mason-lspconfig.nvim'
      
    , 'nvim-telescope/telescope-project.nvim'
    , 'nvim-telescope/telescope.nvim'
    , "HUAHUAI23/telescope-session.nvim"
    , "nvim-treesitter/nvim-treesitter"
    , "jose-elias-alvarez/null-ls.nvim"
    , "simrat39/rust-tools.nvim"
  }
end

packer_setup(plugins())
require 'hop'.setup {
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

require("mason").setup({ 
    PATH = "prepend", -- "skip" seems to cause the spawning error
})
local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
  null_ls.builtins.formatting.rustfmt ,
  null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
})


