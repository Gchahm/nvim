local lsp_zero = require('lsp-zero')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Show hover information' }))
    vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    vim.keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
    vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
    vim.keymap.set('n', '<leader>go', '<cmd>lua vim.lsp.buf.type_definition()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))
    vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Show references' }))
    vim.keymap.set('n', '<leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Show signature help' }))
    vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
        vim.tbl_extend('force', opts, { desc = 'Format code' }))
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>',
        vim.tbl_extend('force', opts, { desc = 'Show code actions' }))

    lsp_zero.buffer_autoformat()
end

lsp_zero.extend_lspconfig({
    sign_text = true,
    lsp_attach = lsp_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

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

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
    },
    mapping = cmp.mapping.preset.insert({
        -- Navigate between completion items
        ['<C-n>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
        ['<C-p>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

        -- `Enter` key to confirm completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Ctrl+Space to trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Navigate between snippet placeholder
        -- ['<C-f>'] = cmp_action.vim_snippet_jump_forward(),
        -- ['<C-b>'] = cmp_action.vim_snippet_jump_backward(),

        -- Scroll up and down in the completion documentation
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
})
