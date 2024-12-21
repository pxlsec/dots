return {
	"krady21/compiler-explorer.nvim",
	config = function()
		require("compiler-explorer").setup({
			url = "https://godbolt.org",
			infer_lang = true, -- Try to infer possible language based on file extension.
			line_match = {
				highlight = true, -- highlight the matching line(s) in the other buffer.
				jump = false, -- move the cursor in the other buffer to the first matching line.
			},
			open_qflist = false, --  Open qflist after compilation if there are diagnostics.
			split = "split", -- How to split the window after the second compile (split/vsplit).
			compiler_flags = "", -- Default flags passed to the compiler.
			job_timeout_ms = 25000, -- Timeout for libuv job in milliseconds.
			languages = { -- Language specific default compiler/flags
				c = {
					compiler = "gcc",
					compiler_flags = "-O3 --march=native -Wall",
				},
			},
		})
	end,
}
