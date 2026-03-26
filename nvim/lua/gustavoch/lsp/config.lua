local capabilities = vim.tbl_deep_extend(
    'force',
    require('cmp_nvim_lsp').default_capabilities(),
    {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    }
)

vim.lsp.config('*', {
    capabilities = capabilities,
})

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        },
    },
})

vim.lsp.enable({ 'ts_ls', 'eslint', 'lua_ls', 'elixir_ls' })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Show hover information' }))
        vim.keymap.set('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
        vim.keymap.set('n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
        vim.keymap.set('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
        vim.keymap.set('n', '<leader>gy', '<cmd>lua vim.lsp.buf.type_definition()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))
        vim.keymap.set('n', '<leader>gu', '<cmd>lua vim.lsp.buf.references()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Show usages/references' }))
        vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
            vim.tbl_extend('force', opts, { desc = 'Format code' }))
        vim.keymap.set('n', '<leader>am', '<cmd>lua vim.lsp.buf.code_action()<cr>',
            vim.tbl_extend('force', opts, { desc = 'Code actions' }))
    end,
})
