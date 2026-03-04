return {
    "nvim-telescope/telescope.nvim",

    branch = "master",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/which-key.nvim",
    },

    config = function()
        require('telescope').setup({})
        local builtin = require('telescope.builtin')

        local wk = require("which-key")
        wk.add({
            { "<leader>p", group = "Project" },
            { "<leader>f", group = "File" },
            { "<leader>w", group = "Window" },
            { "<leader>e", group = "Errors" },
            { "<leader>g", group = "Go to" },
            { "<leader>r", group = "Refactor" },
            { "<leader>a", group = "Actions" },
            { "<leader>z", group = "Folds" },
            { "<leader>n", group = "Terminal" },
            { "<leader>s", group = "Search/Replace" },
        })

        -- Recent files
        vim.keymap.set('n', '<leader><leader>', builtin.oldfiles, { desc = "Recent files" })

        -- Find in file
        vim.keymap.set('n', '<leader>ff', builtin.current_buffer_fuzzy_find, { desc = "Find in file" })

        -- Format with LSP
        vim.keymap.set('n', '<leader>fl', function()
            vim.lsp.buf.format({ async = true })
        end, { desc = "Format file" })

        -- Find files in the current project
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = "Find files" })

        -- Find buffers
        vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "Find buffers" })

        -- Live grep (find in path)
        vim.keymap.set('n', '<leader>pr', builtin.live_grep, { desc = "Find in path" })

        -- Go to action (commands)
        vim.keymap.set('n', '<leader>pa', builtin.commands, { desc = "Go to action" })

        -- Recent locations (jumplist)
        vim.keymap.set('n', '<leader>pl', builtin.jumplist, { desc = "Recent locations" })

        -- Search everywhere (all builtins)
        vim.keymap.set('n', '<leader>as', builtin.builtin, { desc = "Search everywhere" })

        -- List files in a Git repository
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Find Git files" })

        -- Search for the word under the cursor
        vim.keymap.set('n', '<leader>psw', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Search word under cursor" })

        -- Search for the WORD under the cursor
        vim.keymap.set('n', '<leader>psW', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Search WORD under cursor" })

        -- Prompt search
        vim.keymap.set('n', '<leader>pss', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Search for user input" })

        -- Help tags
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Help tags" })
    end
}
