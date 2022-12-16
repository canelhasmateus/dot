local function packer_setup(plugins)

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
    , "preservim/nerdtree" 
    
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
  }
end

packer_setup(plugins())
require'hop'.setup{
  uppercase_labels = true,
}
