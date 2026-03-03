return {
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'stevearc/conform.nvim' },
    -- snippets templates
    { "rafamadriz/friendly-snippets" },
    -- snippets server
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    -- snippets server for cmp
    { 'saadparwaiz1/cmp_luasnip' },
    -- make suggestions pretty
    { 'onsails/lspkind.nvim' },
}
