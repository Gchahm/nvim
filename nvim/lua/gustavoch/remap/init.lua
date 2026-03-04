vim.g.mapleader = " "

-- jk to escape insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Pane navigation (Alt+hjkl)
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Navigate to left pane" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Navigate to right pane" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Navigate to upper pane" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Navigate to lower pane" })

-- Buffer navigation (Alt+n/p)
vim.keymap.set("n", "<A-n>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<A-p>", "<cmd>bprev<CR>", { desc = "Previous buffer" })

-- Indent with reselect
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Execute macro in q register
vim.keymap.set("n", "qj", "@q", { desc = "Execute macro in q register" })

-- File explorer
vim.keymap.set("n", "<leader>x", vim.cmd.Ex, { desc = "Open file explorer" })

-- Close buffer
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Window management
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>wu", "<cmd>close<CR>", { desc = "Close split" })
vim.keymap.set("n", "<leader>wm", "<C-w>x", { desc = "Swap window" })

-- Folds (via ufo)
vim.keymap.set("n", "<leader>zc", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
vim.keymap.set("n", "<leader>zo", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })

-- Diagnostics navigation
vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- Terminal
vim.keymap.set("n", "<leader>nt", "<cmd>terminal<CR>", { desc = "Open terminal" })

-- Move selected text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

-- Join lines while keeping cursor position
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines while keeping cursor position" })

-- Scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Search result and center
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- Paste without yanking
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank entire line to system clipboard" })

-- Delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- Exit insert mode with C-c
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

-- Disable Q
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q key" })

-- Tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Start tmux-sessionizer" })

-- Quickfix navigation
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item and center" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item and center" })

-- Search and replace
vim.keymap.set("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Search and replace word under cursor" })
vim.keymap.set("n", "<leader>sW", [[:%s/\<<C-r><C-W>\>/<C-r><C-W>/gI<Left><Left><Left>]],
    { desc = "Search and replace WORD under cursor" })

-- Surround shortcuts
vim.keymap.set("v", '<leader>"', 'c""<esc>P', { desc = "Enclose in double quotes" })
vim.keymap.set("v", "<leader>'", "c''<esc>P", { desc = "Enclose in single quotes" })
vim.keymap.set("v", "<leader>{", "c{}<esc>P", { desc = "Enclose in curly braces" })
vim.keymap.set("v", "<leader>[", "c[]<esc>P", { desc = "Enclose in square brackets" })
vim.keymap.set("v", "<leader>(", "c()<esc>P", { desc = "Enclose in parentheses" })

-- Clear search highlight
vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlight" })
