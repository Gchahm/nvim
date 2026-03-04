return {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
        require("flash").setup()

        vim.keymap.set({ "n", "x", "o" }, "<leader>j", function()
            require("flash").jump()
        end, { desc = "Flash jump" })
    end
}
