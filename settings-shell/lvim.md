lvim/init.lua
    lua lvim/lua/bootstrap:::init.lua  <| LUNARVIM_BASE_DIR
        def reload
        def require_clean
        def require_safe
        env LUNARVIM_RUNTIME_DIR
        env LUNARVIM_CONFIG_DIR
        env LUNARVIM_CACHE_DIR
        env PACKDIR = RUNTIME_DIR + "/site/pack"
        env PACKER_INSTALL = RUNTIME_DIR + "/site/pack/packer/start/packer.nvim"
        env PACKER_CACHE = RUNTIME_DIR + "/plugin/packer_compiled.lua"
        x-> lvim/lua/impatient
        --> lvim/lua/config/init
            def lvim = lvim/lua/config/defaults
            def lvim.lsp = lvim/lua/config
            def lvim.builtins.luasnip.sources.friendly_snippets = true
            lua lvim/lua/keymappings:::load_defaults()
            def builtins.config = lvim.core.builtin
            lua lvim/lua/config/settings:::load_defaults()
            lua lvim/lua/core/autocmds:::load_defaults()
            lua lvim/lua/config/_deprecated:::handle()
        --> lvim/lua/plugin-loader/init <| PACKDIR , PACKER_INSTALL
        --> lvim/lua/mason/bootstrap
        --> lvim/lua/utils/hooks/run-pre-update.lua
        --> lvim/lua/utils/git/update-base-lvim.lua
        --> lvim/lua/utils/hook/run-post-update.lua

    lua lvim/lua/config:::load()
        

    lua lvim/lua/plugin-loader:::load() <| lvim/lua/plugins 
        var compile_path 
        var snapshot_path
        var default_snapshot
        ( for plugin in args: use(plugin) )

    lua lvim/lua/core/theme:::setup()
        var selected theme
        fun plugin.setup( lvim.builtim.theme[
            selected_theme
        ].options)
        def vim.g.colors = colorscheme
        
        lua lvim/lua/core/lualine:::setup()
        lua lvim/lua/core/lir:::icon_setup()
    
    lua lvim/lua/core/commands:::load() <| commands.default 
        def quickFixToggle 
        def bufferKill
        def toggleFormatOnSave
        def LvimInfo
        def lvimDocs
        def lvimCacheReset
        def lvimReload
        def lvimUpdate
        def lvimSyncCorePlugins
        def lvimChangelog
        def livmVersion
        def lvimOpenLog
        
    lua lvim/lua/lsp:::setup()
        for each lvim.lsp.diagnostis.signs , sign_define
        lua lvim.lsp.handlers:::setup()
        lua lvim.lsp.templates:::generate_templates()
        lua nlspsettings:::setup( )
        lua mason-lspconfig:::setup()
        lua lvim.lsp.null-ls:::setup()
        autocmds.configure_format_on_save()
 

___


