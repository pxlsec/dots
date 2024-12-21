-- All options are set in this file!
local opt = vim.opt
local g = vim.g

vim.g.nvim_tree_disable_netrw = 1
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.g.instant_username = "pxl"

vim.filetype.add({
	extension = {
		vert = "glsl",
		frag = "glsl",
		rgen = "glsl",
		rchit = "glsl",
		rmiss = "glsl",
	},
})

-- for ufo
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

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
opt.clipboard = "unnamedplus"

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

-- -- Foldies
-- vim.o.foldcolumn = "1" -- '0' is not bad
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
--
-- -- Colors and themes
-- vim.opt.background = "dark" -- set this to dark or light
-- vim.cmd.colorscheme("catppuccin-macchiato")
--
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = NONE, fg = NONE })
--
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
--
-- -- Colors for the sign colomn
-- vim.api.nvim_set_hl(0, "SignColumn", { bg = NONE })
-- vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = NONE, fg = "#00ff00" })
-- vim.api.nvim_set_hl(0, "GitSignsChange", { bg = NONE, fg = "#ffff00" })
-- vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = NONE, fg = "#ff0000" })
