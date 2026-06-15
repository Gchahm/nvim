return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
        { "<leader>fe", "<cmd>Neotree reveal<cr>", desc = "Reveal current file in explorer" },
    },
    opts = {
        filesystem = {
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
        },
        window = {
            width = 35,
            mappings = {
                ["h"] = "close_node",
                ["l"] = "open",
                ["P"] = { "toggle_preview", config = { use_float = false, use_image_nvim = false } },
            },
        },
    },
}
