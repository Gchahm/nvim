return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.8",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep"
    },

    config = function()
        require('telescope').setup({})
        local builtin = require('telescope.builtin')

        -- Find files in the current project using Telescope's built-in `find_files`
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find files" })

        vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "Find buffers" })

        -- List files in a Git repository using Telescope's `git_files`
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Find Git files" })

        -- Search for the word under the cursor in the current project using `grep_string`
        vim.keymap.set('n', '<leader>psw', function()
            local word = vim.fn.expand("<cword>")  -- Get the word under the cursor
            builtin.grep_string({ search = word })
        end, { desc = "Search word under cursor" })

        -- Search for the WORD (sequence of non-whitespace characters) under the cursor
        vim.keymap.set('n', '<leader>psW', function()
            local word = vim.fn.expand("<cWORD>")  -- Get the WORD under the cursor
            builtin.grep_string({ search = word })
        end, { desc = "Search WORD under cursor" })

        -- Prompt the user for input and search for the given string in the current project
        vim.keymap.set('n', '<leader>pss', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Search for user input" })

        -- Open help tags using Telescope to browse Neovim help documentation
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Help tags" })

   end
}

