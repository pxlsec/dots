vim.g.mapleader = " "
vim.o.mouse = ""
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.laststatus = 3
vim.o.wrap = false
vim.o.undofile = true

vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.keymap.set({ "n", "v", "x" }, "<leader>cf", vim.lsp.buf.format)
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>T", ":TransparentToggle<CR>")

vim.keymap.set({ "n", "v", "x" }, "j", "gj")
vim.keymap.set({ "n", "v", "x" }, "<Down>", "gj")
vim.keymap.set({ "n", "v", "x" }, "k", "gk")
vim.keymap.set({ "n", "v", "x" }, "<Up>", "gk")

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/xiyaowong/transparent.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/onsails/lspkind.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/b0o/incline.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("^2") },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
})

-- Treesitter
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		if args.data.kind == "update" and args.data.spec.name == "nvim-treesitter" then
			vim.cmd(":TSUpdate")
			vim.notify("Updating Treesitter Parsers")
		end
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "<filetype>" },
	callback = function()
		vim.treesitter.start()
	end,
})
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- LSP settings

require("mason").setup({
	ui = {
		icons = {
			package_installed = "󰄲",
			package_pending = "󱑣",
			package_uninstalled = "󰄱",
		},
	},
})
require("mason-lspconfig").setup()
vim.keymap.set("n", "<leader>tm", ":Mason<CR>")

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		if args.data.kind == "update" and args.data.spec.name == "mason" then
			vim.cmd(":MasonUpdate")
			vim.notify("Updating LSP Servers")
		end
	end,
})

vim.lsp.config("zls", {
	enable_build_on_save = true,
	build_on_save_args = { "-fno-bin", "-fincremental" },
})

require("mason-nvim-dap").setup({
	-- ensure_installed = {'stylua', 'jq'},
	handlers = {}, -- sets up dap in the predefined manner
})

require("nvim-dap-virtual-text").setup({
	virt_text_win_col = 80,
	highlight_changed_variables = true,
})

-- vim.lsp.enable({ "lua_ls", "clangd", "zls" })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.opt.completeopt:append("noselect")

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local mode = vim.api.nvim_get_mode().mode
		local filetype = vim.bo.filetype
		if vim.bo.modified == true and mode == "n" and filetype ~= "oil" then
			vim.cmd("lua vim.lsp.buf.format()")
		else
		end
	end,
})

vim.diagnostic.config({
	underline = true,
	signs = {
		active = true,
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "󰟃",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
	virtual_text = false,
	float = {
		-- border = "single",
		format = function(diagnostic)
			return string.format(
				"%s (%s) [%s]",
				diagnostic.message,
				diagnostic.source,
				diagnostic.code or diagnostic.user_data.lsp.code
			)
		end,
	},
})

require("blink.cmp").setup({
	keymap = {
		preset = "default",
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = {
			auto_show = false,
		},
		ghost_text = {
			enabled = true,
			show_with_menu = false,
		},
		list = { selection = { preselect = true, auto_insert = true } },
		menu = {
			auto_show = false,
			draw = {
				-- columns = {
				--     { "label",     "label_description", gap = 1 },
				--     { "kind_icon", gap = 1,             "kind" }
				-- },
				components = {
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							else
								icon = require("lspkind").symbolic(ctx.kind, {
									mode = "symbol",
								})
							end

							return icon .. ctx.icon_gap
						end,

						-- Optionally, use the highlight groups from nvim-web-devicons
						-- You can also add the same function for `kind.highlight` if you want to
						-- keep the highlight groups in sync with the icons.
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							end
							return hl
						end,
					},
				},
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
	snippets = {
		preset = "luasnip",
	},
})

vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })

-- Misc
require("fidget").setup({
	notification = {
		override_vim_notify = true, -- Automatically override vim.notify() with Fidget
	},
})

require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "┃" },
		topdelete = { text = "┃" },
		changedelete = { text = "┃" },
		untracked = { text = "┃" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "┃" },
		topdelete = { text = "┃" },
		changedelete = { text = "┃" },
		untracked = { text = "┃" },
	},
})

-- Nav
local oil = require("oil")
oil.setup({
	default_file_explorer = false, -- Breaks spellfile downloading
	float = {
		max_width = 0.6,
		max_height = 0.6,
	},
})
vim.keymap.set("n", "<leader>fe", oil.toggle_float, { noremap = true, silent = true })

-- folke/rename integration
vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions[1].type == "move" then
			Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
		end
	end,
})

-- Colors

require("tokyonight").setup({
	transparent = true,
})
vim.cmd.colorscheme("tokyonight-moon")

vim.opt.fillchars:append("eob: ")

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

local snacks = require("snacks")
snacks.setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	-- bigfile = { enabled = true },
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	-- explorer = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	picker = { enabled = true },
	notifier = { enabled = true },
	-- quickfile = { enabled = true },
	-- scope = { enabled = true },
	-- scroll = { enabled = true },
	-- statuscolumn = { enabled = true },
	-- words = { enabled = true },
})

vim.keymap.set("n", "grr", snacks.picker.lsp_references, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ff", snacks.picker.files, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", snacks.picker.grep, { noremap = true, silent = true })

-- require("indentmini").setup({
--     char = '┃'
-- })
-- vim.cmd.highlight('IndentLine guifg=#2B2D3A')
-- vim.cmd.highlight('IndentLineCurrent guifg=#468a9e')

require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
		lualine_b = { "filename" },
		lualine_c = { "branch", "diff" },
		lualine_x = { "diagnostics", "lsp_status" },
		lualine_y = { "encoding", "filetype" },
		lualine_z = {
			{ "location", separator = { left = "", right = "" }, left_padding = 2 },
		},
	},
	inactive_sections = {
		lualine_a = { "filename" },
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "location" },
	},
	tabline = {},
	extensions = {},
})

-- Incline config
local helpers = require("incline.helpers")
local devicons = require("nvim-web-devicons")
require("incline").setup({
	window = {
		padding = 0,
		margin = { horizontal = 0, vertical = 0 },
		overlap = {
			borders = true,
			statusline = true,
			tabline = true,
			winbar = true,
		},
	},
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if filename == "" then
			filename = "[No Name]"
		end
		local ft_icon, ft_color = devicons.get_icon_color(filename)
		local modified = vim.bo[props.buf].modified
		return {
			ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
			" ",
			{ filename, gui = modified and "bold,italic" or "bold" },
			" ",
		}
	end,
})
