return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",

	dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope-ui-select.nvim" },
	config = function()
		require("telescope").setup({
			defaults = {
				-- Default configuration for telescope goes here:
				-- config_key = value,
				layout_strategy = "horizontal",
				layout_config = { height = 0.6, width = 0.5 },
				mappings = {
					i = {
						-- map actions.which_key to <C-h> (default: <C-/>)
						-- actions.which_key shows the mappings for your picker,
						-- e.g. git_{create, delete, ...}_branch for the git_branches picker
						["<C-h>"] = "which_key",
					},
				},
			},
			pickers = {
				-- Default configuration for builtin pickers goes here:
				-- picker_name = {
				--   picker_config_key = value,
				--   ...
				-- }
				-- Now the picker_config_key will be applied every time you call this
				-- builtin picker
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({
						-- even more opts
					}),

					-- pseudo code / specification for writing custom displays, like the one
					-- for "codeactions"
					-- specific_opts = {
					--   [kind] = {
					--     make_indexed = function(items) -> indexed_items, width,
					--     make_displayer = function(widths) -> displayer
					--     make_display = function(displayer) -> function(e)
					--     make_ordinal = function(e) -> string
					--   },
					--   -- for example to disable the custom builtin "codeactions" display
					--      do the following
					--   codeactions = false,
					-- }
				},
				-- Your extension configuration goes here:
				-- extension_name = {
				--   extension_config_key = value,
				-- }
				-- please take a look at the readme of the extension you want to configure
			},
		})
		require("telescope").load_extension("ui-select")
	end,
}
