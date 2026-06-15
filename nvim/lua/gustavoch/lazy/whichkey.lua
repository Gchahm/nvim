return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            { "<leader>s", group = "settings" },
            { "<leader>w", group = "window/buffer" },
            { "<leader>e", group = "diagnostics" },
            { "<leader>z", group = "folds" },
            { "<leader>m", group = "markdown" },
            { "<leader>f", group = "find/file" },
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
