local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate", -- :MasonUpdate updates registry contents

	dependencies = {
		-- LSP
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",

		"simrat39/rust-tools.nvim",

		--DAP
		"mfussenegger/nvim-dap",
		"jay-babu/mason-nvim-dap.nvim",
	},

	config = function()
		require("mason").setup({ -- mason config
			ui = {
				border = "none",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			log_level = vim.log.levels.INFO,
			max_concurrent_installers = 4,
		})

		require("mason-lspconfig").setup({})

		require("mason-lspconfig").setup_handlers({ -- lsp server configs

			-- The first entry (without a key) will be the default handler
			-- and will be called for each installed server that doesn't have
			-- a dedicated handler.
			function(server_name) -- default handler (optional)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
				})
			end,

			-- Next, you can provide a dedicated handler for specific servers.
			-- For example, a handler override for the `rust_analyzer`:
			["rust_analyzer"] = function()
				require("rust-tools").setup({})
			end,
		})

		require("mason-nvim-dap").setup({
			handlers = {},
		})
	end,
}
