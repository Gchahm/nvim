return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "_" },
            topdelete    = { text = "‾" },
            changedelete = { text = "▎" },
            untracked    = { text = "▎" },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        attach_to_untracked = true,
    },
    config = function(_, opts)
        require("gitsigns").setup(opts)

        -- WebStorm-style colors
        local set_hl = function(group, fg)
            vim.api.nvim_set_hl(0, group, { fg = fg, default = false })
        end
        local green = "#62B543"
        local blue  = "#4787D8"
        local red   = "#C75450"

        set_hl("GitSignsAdd",          green)
        set_hl("GitSignsChange",       blue)
        set_hl("GitSignsDelete",       red)
        set_hl("GitSignsTopdelete",    red)
        set_hl("GitSignsChangedelete", blue)
        set_hl("GitSignsUntracked",    green)
    end,
}
