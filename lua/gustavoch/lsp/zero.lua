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
