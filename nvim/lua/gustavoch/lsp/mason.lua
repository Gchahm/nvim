local lsp_zero = require('lsp-zero')

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'tsserver', 'eslint', 'lua_ls' },
    automatic_enable = false,
})

require('lspconfig').lua_ls.setup({
    on_init = function(client)
        lsp_zero.nvim_lua_settings(client, {})
    end
})

require('lspconfig').tsserver.setup({
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        client.server_capabilities.document_formatting = false
    end,
})

require('lspconfig').eslint.setup({
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        client.server_capabilities.document_formatting = false
    end,
    settings = {
        validate = "on",
    },
})

require("mason-null-ls").setup({
    ensure_installed = { "prettier" },
    automatic_installation = true,
})
