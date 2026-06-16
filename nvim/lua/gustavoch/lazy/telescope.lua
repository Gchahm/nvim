return {
    "nvim-telescope/telescope.nvim",

    branch = "master",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "folke/which-key.nvim",
    },

    config = function()
        local vimgrep_arguments
        if vim.fn.executable('rg') == 0 then
            vimgrep_arguments = { 'grep', '-r', '-n', '-E', '--color=never', '-I' }
        else
            -- ripgrep defaults, plus --follow so symlinked dirs (e.g. the
            -- symlinked repos under an aggregator repo) get searched.
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--follow',
            }
        end

        require('telescope').setup({
            defaults = {
                vimgrep_arguments = vimgrep_arguments,
            },
        })
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

        -- Go to file (find files)
        local show_hidden = false
        vim.keymap.set('n', '<leader>po', function()
            builtin.find_files({ hidden = show_hidden, no_ignore = show_hidden })
        end, { desc = "Go to file" })
        vim.keymap.set('n', '<leader>p.', function()
            show_hidden = not show_hidden
            vim.notify("Find files: hidden " .. (show_hidden and "shown" or "hidden"))
        end, { desc = "Toggle hidden files" })

        -- Find buffers
        vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = "Find buffers" })

        -- Find in path (live grep)
        vim.keymap.set('n', '<leader>pf', builtin.live_grep, { desc = "Find in path" })

        -- Replace in path
        vim.keymap.set('n', '<leader>pr', function()
            local search = vim.fn.input("Search: ")
            if search == "" then return end
            local replace = vim.fn.input("Replace with: ")
            if replace == "" then return end
            vim.cmd("silent! vimgrep /" .. vim.fn.escape(search, "/\\") .. "/gj **/*")
            vim.cmd("cfdo %s/" .. vim.fn.escape(search, "/\\") .. "/" .. vim.fn.escape(replace, "/\\") .. "/gc | update")
        end, { desc = "Replace in path" })

        -- Go to action (commands)
        vim.keymap.set('n', '<leader>pa', builtin.commands, { desc = "Go to action" })

        -- Recent locations (jumplist)
        vim.keymap.set('n', '<leader>pl', builtin.jumplist, { desc = "Recent locations" })

        -- New scratch file
        vim.keymap.set('n', '<leader>ps', function()
            vim.cmd("enew")
            vim.bo.buftype = "nofile"
            vim.bo.bufhidden = "wipe"
            vim.bo.swapfile = false
        end, { desc = "New scratch file" })

        -- Search everywhere (all builtins)
        vim.keymap.set('n', '<leader>as', builtin.builtin, { desc = "Search everywhere" })

        -- Git (Telescope)
        vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Find Git files" })
        vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = "Git branches" })
        vim.keymap.set('n', '<leader>gl', builtin.git_commits, { desc = "Git log" })
        vim.keymap.set('n', '<leader>gL', builtin.git_bcommits, { desc = "Git log (current file)" })
        vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = "Git stash" })

        -- Search for the word under the cursor
        vim.keymap.set('n', '<leader>fw', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end, { desc = "Search word under cursor" })

        -- Search for the WORD under the cursor
        vim.keymap.set('n', '<leader>fW', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end, { desc = "Search WORD under cursor" })

        -- Prompt search
        vim.keymap.set('n', '<leader>fs', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, { desc = "Search for user input" })

        -- Help tags
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Help tags" })
    end
}
