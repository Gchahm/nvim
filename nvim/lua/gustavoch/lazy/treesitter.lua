return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local ensure = { "c", "cpp", "javascript", "typescript", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
        for _, lang in ipairs(ensure) do
            pcall(vim.treesitter.language.add, lang)
        end

        vim.api.nvim_create_autocmd("FileType", {
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end
}
