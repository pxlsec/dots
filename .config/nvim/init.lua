-- Options --
vim.g.mapleader = " "

vim.o.mouse = ""
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 10

vim.o.signcolumn = "yes:1"
vim.o.winborder = "none"
vim.o.laststatus = 3
vim.o.wrap = false
vim.o.undofile = true

vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.updatetime = 250

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = "0"

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		-- Don't show in insert mode
		if vim.api.nvim_get_mode().mode ~= "n" then
			return
		end

		-- Only show if there's actually a diagnostic under cursor
		local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
		if vim.tbl_isempty(diagnostics) then
			return
		end

		vim.diagnostic.open_float(nil, {
			focusable = false,
			border = "rounded",
			source = "if_many",
			scope = "cursor",
		})
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

vim.keymap.set({ "n" }, "<leader>", "<Nop>", { silent = true })
vim.keymap.set({ "i", "v", "x" }, "<F13>", "<Esc>", { desc = "Caps Lock to Normal Mode" }) -- Note that caps lock is configured to emit <F13> in hyprland.
vim.keymap.set({ "n" }, "<F13>", "<cmd>noh<CR>")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>T", "<cmd>TransparentToggle<CR>")

vim.keymap.set({ "n", "v", "x" }, "j", "gj")
vim.keymap.set({ "n", "v", "x" }, "<Down>", "gj")
vim.keymap.set({ "n", "v", "x" }, "k", "gk")
vim.keymap.set({ "n", "v", "x" }, "<Up>", "gk")

vim.keymap.set({ "n" }, "<leader>wv", function()
	vim.cmd("vsplit")
end)

vim.keymap.set({ "n" }, "<leader>wh", "<C-w>h")
vim.keymap.set({ "n" }, "<leader>wj", "<C-w>j")
vim.keymap.set({ "n" }, "<leader>wk", "<C-w>k")
vim.keymap.set({ "n" }, "<leader>wl", "<C-w>l")

vim.keymap.set({ "n" }, "<leader>nu", vim.pack.update)
vim.keymap.set({ "n" }, "<leader>nr", function()
	-- Clear the cache for your custom modules
	-- Replace "user" with the name of your config folder
	for name, _ in pairs(package.loaded) do
		if name:match("^user") then
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)

	print("Reloaded config!")
end)

----------------
-- Treesitter --
----------------
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

require("nvim-treesitter").install({
	"comment",
	"regex",
	"query",
	"vimdoc",
	"markdown",
	"markdown_inline",
	"lua",
	"c",
	"zig",
})

-- Auto update parsers on vim.pack.update()
vim.api.nvim_create_autocmd("packchanged", {
	callback = function(args)
		if args.data.kind == "update" and args.data.spec.name == "nvim-treesitter" then
			vim.cmd(":TSUpdate")
			vim.notify("Updating Treesitter Parsers")
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

		-- Return if lang = nil
		if not lang then
			return
		end

		-- Check if the parser is insatlled
		if not vim.treesitter.language.add(lang) then
			-- If not installed, check if it can be insatlled and install
			local configs = require("nvim-treesitter.parsers")
			if not configs[lang] ~= nil then
				return
			end
			if not require("nvim-treesitter").install(lang) then
				return
			end
		end

		-- Start the treesitter!
		vim.treesitter.start(args.buf, lang)
	end,
})

-----------
-- Mason --
-----------
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
})

require("mason").setup({
	ui = {
		icons = {
			package_installed = "󰄲",
			package_pending = "󱑣",
			package_uninstalled = "󰄱",
		},
	},
})

---------
-- LSP --
---------
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

require("mason-lspconfig").setup()
vim.keymap.set("n", "<leader>tm", "<cmd>Mason<CR>")

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		if args.data.kind == "update" and args.data.spec.name == "mason" then
			vim.notify("Updating LSP Servers")
			vim.cmd(":MasonUpdate")
		end
	end,
})

vim.lsp.config["zls"] = {
	settings = {
		semantic_tokens = "partial",
		build_on_save_args = { "-fincremental" },
	},
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "zls" })

----------------
-- Formatters --
----------------
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim.git" },
})

require("conform").setup({
    default_format_opts = {
        lsp_format = "fallback",
    },
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		htmlangular = { "prettierd", "prettier", stop_after_first = true },
		sh = { "shfmt" },
	},
})

vim.keymap.set({ "n", "v", "x" }, "<leader>cf", function()
	require("conform").format({
		async = true,
	})
end)
---------
-- DAP --
---------
vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
})

require("nvim-dap-virtual-text").setup({
	virt_text_win_col = 80,
	highlight_changed_variables = true,
})

vim.keymap.set("n", "<leader>dc", require("dap").continue, {})
vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, {})
vim.keymap.set("n", "<leader>dr", require("dap").repl.open, {})

vim.keymap.set("n", "<down>", require("dap").step_over, {})
vim.keymap.set("n", "<right>", require("dap").step_into, {})
vim.keymap.set("n", "<left>", require("dap").step_out, {})
vim.keymap.set("n", "<up>", require("dap").step_back, {}) -- Debug adapter must support reverse debugging.

require("dap").adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-dap", -- adjust as needed, must be absolute path
	name = "lldb",
}

require("dap").configurations.zig = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- 💀
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		-- runInTerminal = false,
	},
}

----------------
-- Completion --
----------------
vim.pack.add({
	{ src = "https://github.com/onsails/lspkind.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("^2") },
})

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-space>"] = { "show_and_insert", "hide" },

		["<Tab>"] = {
			function(cmp)
				if cmp.is_active() then
					return cmp.select_next()
				end
			end,

			"snippet_forward",
			"fallback",
		},

		["<S-Tab>"] = {
			function(cmp)
				if cmp.is_active() then
					return cmp.select_prev()
				end
			end,

			"snippet_backward",
			"fallback",
		},

		["<CR>"] = {
			function(cmp)
				if cmp.is_menu_visible() then
					return cmp.select_and_accept()
				end
			end,

			"fallback",
		},

		["j"] = {
			function(cmp)
				if cmp.is_documentation_visible() then
					return cmp.scroll_documentation_up()
				end
			end,

			"fallback",
		},

		["k"] = {
			function(cmp)
				if cmp.is_documentation_visible() then
					return cmp.scroll_documentation_down()
				end
			end,

			"fallback",
		},

		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
		},
		ghost_text = {
			enabled = true,
			show_with_selection = true,
			show_with_menu = true,
		},
		list = { selection = { preselect = true, auto_insert = false } },
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

-----------
-- Theme --
-----------
vim.pack.add({
	{ src = "https://github.com/nyoom-engineering/oxocarbon.nvim.git" },
	{ src = "https://github.com/xiyaowong/transparent.nvim" },
})

vim.cmd.colorscheme("oxocarbon")

vim.opt.fillchars:append("eob: ")

--------
-- UI --
--------
vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/folke/noice.nvim" },
})

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

vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
})
require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { { "mode", separator = { left = "", right = "" }, right_padding = 2 } },
		lualine_b = { "filename" },
		lualine_c = { "branch", "diff" },
		lualine_x = { "diagnostics", "lsp_status" },
		lualine_y = { "encoding", "filetype" },
		lualine_z = {
			{ "location", separator = { left = "", right = "" }, left_padding = 2 },
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

-- gitsigns --
vim.pack.add({
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
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

-- Incline --
vim.pack.add({
	{ src = "https://github.com/b0o/incline.nvim" },
})
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

-- Aerial --
vim.pack.add({
	{ src = "https://github.com/stevearc/aerial.nvim.git" },
})
require("aerial").setup({
	layout = {
		placement = "edge",
		min_width = 20,
	},
})

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- Oil --
vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})
require("oil").setup({
	default_file_explorer = false, -- Breaks spellfile downloading
	float = {
		max_width = 0.6,
		max_height = 0.6,
		preview_split = "right",
	},
	keymaps = {
		["q"] = { "actions.close", mode = "n" },
	},
})
vim.keymap.set("n", "<leader>fe", require("oil").toggle_float, { noremap = true, silent = true })

-- folke/rename integration
vim.api.nvim_create_autocmd("User", {
	pattern = "OilActionsPost",
	callback = function(event)
		if event.data.actions[1].type == "move" then
			Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/vyfor/cord.nvim.git" },
})

require("cord").setup({
	display = { theme = "minecraft" },
})

local function open_local_asm()
	local src_file = vim.api.nvim_buf_get_name(0)
	local lang = vim.bo.filetype

	-- High-performance engine defaults: ReleaseFast + Native CPU features
	local cmd = ""
	if lang == "zig" then
		cmd = string.format("zig build-obj %s -fstrip -femit-asm=- -O ReleaseFast -mcpu=native", src_file)
	elseif lang == "cpp" or lang == "c" then
		cmd = string.format("clang++ -S -o - -O3 -march=native %s", src_file)
	else
		print("Unsupported language for local asm")
		return
	end

	-- Create or find the scratch buffer
	local asm_bufname = "asm_explorer"
	local asm_buf = -1
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_get_name(buf):match(asm_bufname) then
			asm_buf = buf
			break
		end
	end

	if asm_buf == -1 then
		asm_buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
		vim.api.nvim_buf_set_name(asm_buf, asm_bufname)
	end

	-- Run compilation and capture stdout
	local output = vim.fn.systemlist(cmd)

	-- Clean up and populate buffer
	vim.api.nvim_buf_set_option(asm_buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(asm_buf, 0, -1, false, output)
	vim.api.nvim_buf_set_option(asm_buf, "filetype", "asm")
	vim.api.nvim_buf_set_option(asm_buf, "modifiable", false)

	-- Ensure buffer is displayed in a split
	local win = vim.fn.bufwinnr(asm_buf)
	if win == -1 then
		vim.cmd("vsplit")
		vim.api.nvim_set_current_buf(asm_buf)
	end
end

vim.keymap.set("n", "<leader>ce", open_local_asm, { desc = "Local CE Scratch Buffer" })
