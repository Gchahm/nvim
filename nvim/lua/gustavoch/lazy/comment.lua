return {
    "numToStr/Comment.nvim",
    config = function()
        require("Comment").setup()

        local api = require("Comment.api")
        vim.keymap.set("n", "<leader>c", api.toggle.linewise.current, { desc = "Toggle comment" })
        vim.keymap.set("v", "<leader>c", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
            { desc = "Toggle comment" })
    end
}
