function ColorMyPencils(color)

	color = color or "dracula"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    lazy = false,
    opts = {},
    config = function()
        ColorMyPencils()
    end
    },
    {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    opts = {},
    }
}
