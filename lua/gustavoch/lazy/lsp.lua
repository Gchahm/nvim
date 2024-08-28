return {
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v4.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'jayp0521/mason-null-ls.nvim' },
    { 'jose-elias-alvarez/null-ls.nvim' },
    -- snippets templates
    { "rafamadriz/friendly-snippets" },
    { "jose-elias-alvarez/null-ls.nvim" },
    -- snippets server
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    -- snippets server for cmp
    { 'saadparwaiz1/cmp_luasnip' },
    -- make suggestions pretty
    { 'onsails/lspkind.nvim' },
}
