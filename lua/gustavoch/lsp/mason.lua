local lsp_zero = require('lsp-zero')

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'tsserver', 'eslint', 'lua_ls' },
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                on_init = function(client)
                    lsp_zero.nvim_lua_settings(client, {})
                end
            })
        end,

        tsserver = function()
            require('lspconfig').tsserver.setup({
                on_attach = function(client, bufnr)
                    -- Define key mappings for LSP functionality
                    local opts = { noremap = true, silent = true }
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
                    -- More mappings as needed

                    -- Disable formatting by tsserver (eslint will handle it)
                    client.server_capabilities.document_formatting = false
                end,
            })
        end,

        eslint = function()
            require('lspconfig').eslint.setup({
                on_attach = function(client, bufnr)
                    -- Define key mappings for LSP functionality
                    local opts = { noremap = true, silent = true }
                    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',
                        opts)

                    client.server_capabilities.document_formatting = false
                end,
                settings = {
                    validate = "on",
                    lint = {
                        -- ESLint specific configurations
                    },
                },
            })
        end,
    },
})

-- If you use mason-null-ls for linters/formatters
require("mason-null-ls").setup({
    ensure_installed = { "prettier" }, -- Install Prettier using Mason
    automatic_installation = true,
})
