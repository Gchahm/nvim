function ColorMyPencils(color)
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "column", { bg = "none" })
    vim.api.nvim_set_hl(0, "normalfloat", { bg = "none" })
end

return {
    {
        "Mofiqul/dracula.nvim",
        name = "dracula",
        lazy = false,
        opts = {},
    },
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = false,
        opts = {},
        config = function()
            ColorMyPencils()
        end
    }
}
