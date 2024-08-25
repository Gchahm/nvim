return {
    "nvim-treesitter/nvim-treesitter",
    build = ":tsupdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- a list of parser names, or "all"
            ensure_installed = { "c", "cpp", "javascript", "typescript", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

            -- install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- automatically install missing parsers when entering buffer
            -- recommendation: set to false if you don"t have `tree-sitter` cli installed locally
            auto_install = true,

            indent = {
                enable = true
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- using this option may slow down your editor, and you may see some duplicate highlights.
                -- instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
        })

        --	local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        --	treesitter_parser_config.templ = {
        --		install_info = {
        --			url = "https://github.com/vrischmann/tree-sitter-templ.git",
        --			files = {"src/parser.c", "src/scanner.c"},
        --			branch = "master",
        --		},
        --	}

        --	vim.treesitter.language.register("templ", "templ")
    end
}
