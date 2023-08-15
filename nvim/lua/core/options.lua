-- All options are set in this file!
local opt = vim.opt
local g = vim.g

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1  

opt.nu = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.splitbelow = true
opt.splitright = true

opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 4
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

vim.cmd[[colorscheme tokyonight-night]]
--opt.colorscheme = "one"
g.airline_theme = 'tokyonight-night'

-- Colors and themes
vim.api.nvim_set_hl(0, 'EndOfBuffer', {bg=NONE, fg=NONE})

-- Colors for the sign colomn
vim.api.nvim_set_hl(0, 'SignColumn', {bg=NONE})
vim.api.nvim_set_hl(0, 'GitSignsAdd', {bg=NONE, fg='#00ff00'})
vim.api.nvim_set_hl(0, 'GitSignsChange', {bg=NONE, fg='#ffff00'})
vim.api.nvim_set_hl(0, 'GitSignsDelete', {bg=NONE, fg='#ff0000'})
