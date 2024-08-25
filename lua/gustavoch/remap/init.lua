vim.g.mapleader = " "

vim.keymap.set("n", "<C-h>", vim.cmd.Ex, { desc = "Open File Explorer" })
vim.keymap.set("n", "<C-l>", "[[:w | Ex | <cr>]]", { desc = "Save and Open File Explorer" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected text up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines while keeping cursor position" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- next greatest remap ever: asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank entire line to system clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Q key" })
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Start tmux-sessionizer" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format code with LSP" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item and center" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item and center" })
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item and center" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item and center" })

vim.keymap.set("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Search and replace word under cursor" })

vim.keymap.set("n", "<leader>sW", [[:%s/\<<C-r><C-W>\>/<C-r><C-W>/gI<Left><Left><Left>]],
    { desc = "Search and replace WORD under cursor" })

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { desc = "Make current file executable", silent = true })

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end, { desc = "source current file" })

vim.keymap.set("v", '<leader>"', 'c""<esc>P', { desc = "enclose selected text in double quotes" })
vim.keymap.set("v", "<leader>'", "c''<esc>P", { desc = "enclose selected text in single quotes" })
vim.keymap.set("v", "<leader>{", "c{}<esc>P", { desc = "enclose selected text in curly braces" })
vim.keymap.set("v", "<leader>[", "c[]<esc>P", { desc = "enclose selected text in square brackets" })
vim.keymap.set("v", "<leader>(", "c()<esc>P", { desc = "Enclose selected text in parentheses" })

vim.api.nvim_set_keymap('n', '<leader>nh', ':nohlsearch<CR>', { noremap = true, silent = true })
