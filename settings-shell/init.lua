--[[
What is Kickstart?

    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information

--]]

vim.cmd("source ~/.config/nvim/vimrc")
vim.cmd("source ~/.config/nvim/lua/keymaps.lua")

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
--  See `:help mapleader`
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- NOTE: For more options, you can see `:help option-list`
--  See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true
-- vim.opt.relativenumber = true

vim.opt.wrap = false
--
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Enable gui colors
vim.opt.termguicolors = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 0

-- Set empty characters for diff chars
vim.opt.fillchars = { diff = " " }
vim.opt.shortmess:append("c")
vim.cmd([[set iskeyword+=-]])

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	group = vim.api.nvim_create_augroup("kickstart-qflist", { clear = true }),
	callback = function()
		vim.keymap.set("n", "nd", function()
			local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
			vim.cmd("cc " .. row)
		end)
	end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.g.rustaceanvim = {
	tools = { enable_clippy = true },
	server = {
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					allFeatures = true,
					command = "clippy",
					extraArgs = { "--no-deps", "--profile=test" },
				},
				cargo = { extraArgs = { "--profile=test" } },
			},
		},
	},
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	"tpope/vim-sleuth",
	"dbakker/vim-paragraph-motion",

	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = { signs = false } },
	{
		-- TODO: Understand how this work, and properly document every keybind I have.
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()
			require("which-key").register({
				["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
				["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
				["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
				["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
				["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("tokyonight-storm")
	-- 		vim.cmd.hi("Comment gui=none")
	-- 	end,
	-- },
	{
		"numToStr/Comment.nvim",
		config = function()
			vim.keymap.set("n", "…", "<Plug>(comment_toggle_linewise_current)")
			-- Toggle in VISUAL mode
			vim.keymap.set("x", "…", "<Plug>(comment_toggle_linewise_visual)")
		end,
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for install instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			-- TODO: What is this telescope-ui-select?
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable telescope extensions, if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "or", builtin.oldfiles, { desc = "[O]earch [R]ecent" })
			vim.keymap.set("n", "of", builtin.buffers, { desc = "[O]pen [F]iles" })
			vim.keymap.set("n", "ol", builtin.jumplist, { desc = "[O]pen [L]ocations" })
			vim.keymap.set("n", "oa", builtin.commands, { desc = "[O]pen [A]ctions" })

			vim.keymap.set("n", "o:", builtin.command_history, { desc = "[O]pen [:]command history" })
			vim.keymap.set("n", "o'", builtin.registers, { desc = "[O]pen [']registers" })
			vim.keymap.set("c", "<C-r>", builtin.command_history, { desc = "Command history" })

			-- vim.keymap.set("n", "oD", builtin.tagstack, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "oQ", builtin.quickfix, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "oç", builtin.diagnostics, { desc = "[O]pen Errors[ç]" })

			vim.keymap.set("n", "nf", builtin.find_files, { desc = "[S]earch [F]iles" })

			vim.keymap.set("n", "n.", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "n?", builtin.help_tags, { desc = "[S]earch [H]elp" })

			vim.keymap.set("n", "oo", builtin.builtin, { desc = "[O]pen [O]verlay Telescope" })

			vim.keymap.set("n", "đk", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "đF", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			-- Slightly advanced example of overriding default behavior and theme

			vim.keymap.set("n", "nT", function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				})
				builtin.current_buffer_fuzzy_find()
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- Also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "đo", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your neovim configuration files
			vim.keymap.set("n", "nx", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "ðx", function()
				builtin.find_files({
					cwd = vim.fn.stdpath("config"),
					follow = true,
					hidden = true,
				})
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local telescope = require("telescope.builtin")
					local map = function(keys, func, desc)
						vim.keymap.set({ "n", "x" }, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("nd", telescope.lsp_definitions, "[G]oto [D]efinition")
					map("nr", telescope.lsp_references, "[G]oto [R]eferences")
					map("ni", telescope.lsp_implementations, "[G]oto [I]mplementation")
					map("nD", telescope.lsp_type_definitions, "Type [D]efinition")
					map("ox", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
					map("ns", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

					map("rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("qq", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("qd", vim.lsp.buf.hover, "Hover Documentation")

					-- TODO: probably remove
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client then
						if client.server_capabilities.documentHighlightProvider then
							vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
								buffer = event.buf,
								callback = vim.lsp.buf.document_highlight,
							})

							vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
								buffer = event.buf,
								callback = vim.lsp.buf.clear_references,
							})
						end

						-- vim.lsp.inlay_hint.enable(event.buf)
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				-- tsserver = {},
				--

				lua_ls = {
					-- cmd = {...},
					-- filetypes { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								-- Tells lua_ls where to find all the Lua files that you have loaded
								-- for your neovim configuration.
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
								-- If lua_ls is really slow on your computer, you can try this instead:
								-- library = { vim.env.VIMRUNTIME },
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu
			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format lua code
				"shellcheck",
				"markdownlint",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						if server_name == "rust_analyzer" then
							return
						end

						local server = servers[server_name] or {}
						require("lspconfig")[server_name].setup({
							cmd = server.cmd,
							settings = server.settings,
							filetypes = server.filetypes,
							-- This handles overriding only values explicitly passed
							-- by the server configuration above. Useful when disabling
							-- certain features of an LSP (for example, turning off formatting for tsserver)
							capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {}),
						})
					end,
				},
			})
		end,
	},

	{ -- Autoformat
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")
			conform.setup({
				notify_on_error = false,
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
				formatters_by_ft = {
					lua = { "stylua" },
					sh = { "shfmt" },
					markdown = { "markdownlint" },
					-- Conform can also run multiple formatters sequentially
					-- python = { "isort", "black" },
					--
					-- You can use a sub-list to tell conform to run *until* a formatter
					-- is found.
					-- javascript = { { "prettierd", "prettier" } },
				},
			})
			vim.keymap.set("n", "rr", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 500,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				markdown = { "markdownlint" },
				sh = { "shellcheck" },
				rust = { "rust_analyzer" },
				-- Use the "*" filetype to run linters on all filetypes.
				-- ['*'] = { 'global linter' },
				-- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
				-- ['_'] = { 'fallback linter' },
			}
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					pcall(lint.try_lint)
				end,
			})
		end,
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets
					-- This step is not supported in many windows environments
					-- Remove the below condition to re-enable on windows
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
			},
			"saadparwaiz1/cmp_luasnip",
			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			-- If you want to add a bunch of pre-configured snippets,
			--    you can use this plugin to help you. It even has snippets
			--    for various frameworks/libraries/etc. but you will have to
			--    set up the ones that are useful for you.
			-- 'rafamadriz/friendly-snippets',
		},
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
				-- For an understanding of why these mappings were
				-- chosen, you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				mapping = cmp.mapping.preset.insert({
					-- Select the [n]ext item
					-- ["Down"] = cmp.mapping.select_next_item(),
					-- Select the [p]revious item
					-- ["Up"] = cmp.mapping.select_prev_item(),
					-- Accept ([y]es) the completion.
					--  This will auto-import if your LSP supports it.
					--  This will expand snippets if the LSP sent a snippet.
					["<tab>"] = cmp.mapping.confirm({ select = true }),
					--  Generally you don't need this, because nvim-cmp will display
					--  completions whenever it has completion options available.
					["ðd"] = cmp.mapping.complete({}),
					-- Think of <c-l> as moving to the right of your snippet expansion.
					--  So if you have a snippet that's like:
					--  function $name($args)
					--    $body
					--  end
					--
					-- <c-l> will move you to the right of each of the expansion locations.
					-- <c-h> is similar, except moving you backwards.
					["ðl"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["ðj"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				},
			})
		end,
	},

	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]parenthen
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Simple and easy statusline.
			--  You could remove this setup call if you don't like it,
			--  and try some other statusline plugin
			require("mini.statusline").setup()

			local jump = require("mini.jump2d")
			local word_start = jump.gen_pattern_spotter("[^%s%p]+")
			local line_start = jump.gen_pattern_spotter("^")
			local line_end = jump.gen_pattern_spotter("$")
			jump.setup({
				spotter = word_start,
				view = { n_steps_ahead = 2 },
				mappings = { start_jumping = "" },
			})

			for _, mode in pairs({ "n", "x", "o" }) do
				vim.keymap.set(mode, "fl", function()
					jump.start({ allowed_lines = { cursor_before = false, cursor_after = true } })
				end)

				vim.keymap.set(mode, "fç", function()
					jump.start({
						spotter = line_end,
						allowed_lines = { cursor_before = false, cursor_after = true },
					})
				end)

				vim.keymap.set(mode, "fj", function()
					jump.start({
						allowed_lines = { cursor_before = true, cursor_after = false },
					})
				end)

				vim.keymap.set(mode, "fh", function()
					jump.start({
						spotter = line_start,
						allowed_lines = { cursor_before = true, cursor_after = false },
					})
				end)
			end

			local files = require("mini.files")
			files.setup({
				mappings = {
					close = "<Esc>",
					go_in = "<Right>",
					go_out = "<Left>",
				},
			})
			--
			vim.keymap.set("n", "<leader>wp", files.open)
			vim.keymap.set("n", "<leader>wP", function()
				files.open(vim.api.nvim_buf_get_name(0))
			end)
			--

			local operators = require("mini.operators")
			operators.setup({
				evaluate = {
					prefix = "<leader>x",
				},
				exchange = {
					prefix = "xx",
					reindent_linewise = false,
				},
				multiply = {
					prefix = "rd",
				},
			})
		end,
	},

	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "bash", "lua", "markdown", "vim", "vimdoc" },
				-- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "I",
						node_incremental = "I",
						scope_incremental = "sI",
						node_decremental = "K",
					},
				},
			})

			-- There are additional nvim-treesitter modules that you can use to interact
			-- with nvim-treesitter. You should go explore a few and see what interests you:
			--
			--    - Incremental selection: Included, see :help nvim-treesitter-incremental-selection-mod
			--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
			--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
		end,
	},

	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-vim-test",
			"vim-test/vim-test",
			{ "mrcjkb/rustaceanvim", version = "^4", ft = { "rust" } },
		},
		config = function()
			local test = require("neotest")
			test.setup({
				adapters = {
					require("neotest-vim-test")({ allow_file_types = { "haskell", "elixir" } }),
					require("rustaceanvim.neotest"),
				},
			})
		end,

			-- stylua: ignore
		keys = {
			{ "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
			{ "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files", },
			{ "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest", },
			{ "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last", },
			{ "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary", },
			{ "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output", },
			{ "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel", },
			{ "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop", },
		},
	},

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--    For additional information see: :help lazy.nvim-lazy.nvim-structuring-your-plugins
	-- { import = 'custom.plugins' },

	{
		"numToStr/FTerm.nvim",
		config = function()
			local ft = require("FTerm")
			ft.setup({
				autoclose = false,
			})

			vim.keymap.set({ "n" }, "<leader>wt", ft.toggle)
			vim.keymap.set({ "t" }, "<C-q>", ft.toggle)
			vim.keymap.set({ "n" }, "<leader>wT", ft.scratch)
		end,
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup({})
			-- stylua: ignore start
			vim.keymap.set("n", "qm", function() harpoon:list():append() end)
			vim.keymap.set("n", "µ", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

			vim.keymap.set("n", "ʝ", function() harpoon:list():select(1) end)
			vim.keymap.set("n", "ĸ", function() harpoon:list():select(2) end)
			vim.keymap.set("n", "ł", function() harpoon:list():select(3) end)
			vim.keymap.set("n", "ł", function() harpoon:list():select(4) end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "ħ", function() harpoon:list():prev() end)
			vim.keymap.set("n", "·", function() harpoon:list():next() end)
			-- stylua: ignore end
		end,
	},
	require("vcs"),
	{
		"chrisgrieser/nvim-spider",
		config = function()
			local spider = require("spider")
			spider.setup()
			vim.keymap.set({ "n", "o", "x" }, "me", function()
				spider.motion("w")
			end)
			vim.keymap.set({ "n", "o", "x" }, "mE", function()
				spider.motion("b")
			end)
		end,
	},
	-- { "kevinhwang91/nvim-bqf" },
}, {})

-- vim: set sts=4 ts=4 sw=4:
