-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "100"


--ufo settings
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Fall back to OSC 52 when no native clipboard tool is available (e.g. inside
-- a docker container). Requires iTerm2 "Applications in terminal may access
-- clipboard" to be enabled. tmux must have `set-clipboard on` to pass through.
if vim.fn.executable('pbcopy') == 0
    and vim.fn.executable('xclip') == 0
    and vim.fn.executable('xsel') == 0
    and vim.fn.executable('wl-copy') == 0 then
    local osc52 = require('vim.ui.clipboard.osc52')
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
        paste = { ['+'] = osc52.paste('+'), ['*'] = osc52.paste('*') },
    }
end
