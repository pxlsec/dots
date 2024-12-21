-- Shorten function name
local trouble = require("trouble.sources.telescope")
local wk = require("which-key")
local telescope = require("telescope.builtin")
local tree = require("nvim-tree.api")
local gitsigns = require("gitsigns")

local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Modes
--  normal_mode = "n",
--  insert_mode = "i",
--  visual_mode = "v",
--  visual_block_mode = "x",
--  term_mode = "t",
--  command_mode = "c",

-- Shifted modes
keymap("n", "t", "i", opts)

-- General navigation
keymap({"n", "v", "x"}, "h", "<Left>", opts)
keymap({"n", "v", "x"}, "n", "<Down>", opts)
keymap({"n", "v", "x"}, "e", "<Up>", opts)
keymap({"n", "v", "x"}, "i", "<Right>", opts)

-- Insert mode navigation
-- keymap("i", "<C-h>", "<Left>", opts)
-- keymap("i", "<C-n>", "<Down>", opts)
-- keymap("i", "<C-e>", "<Up>", opts)
-- keymap("i", "<C-i>", "<Right>", opts)

-- Window navigation
-- keymap("n", "<M-n>", "<C-w>h", opts)
-- keymap("n", "<M-e>", "<C-w>j", opts)
-- keymap("n", "<M-i>", "<C-w>k", opts)
-- keymap("n", "<M-o>", "<C-w>l", opts)

-- LSP
keymap("n", "<space>ca", vim.lsp.buf.code_action, opts)
keymap("n", "<space>q", function()
	vim.lsp.buf.format({ async = true })
end, opts)

-- Folds
keymap("n", "zR", require("ufo").openAllFolds)
keymap("n", "zM", require("ufo").closeAllFolds)
--  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

--  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
--  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
--  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
--  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

-- See `:help K` for why this keymap
--  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

-- Lesser used LSP functionality
--  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--  nmap('<leader>wl', function()
--    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--  end, '[W]orkspace [L]ist Folders')

wk.add({
    { "<leader>c", group = " Code" },
    { "<leader>cd", vim.lsp.buf.definition, desc = " Code Definition" },
    { "<leader>ci", vim.lsp.buf.implementation, desc = " Code Implementation" },
    { "<leader>cr", telescope.lsp_references, desc = " Code References" },
    { "<leader>ct", trouble.open, desc = " Trouble" },
    { "<leader>d", group = " Debug" },
    { "<leader>da", "<cmd> CECompile <cr>", desc = " View assembly" },
    { "<leader>db", "<cmd> DapToggleBreakpoint <cr>", desc = " Toggle Breakpoint" },
    { "<leader>dr", "<cmd> DapContinue <cr>", desc = " Start or continue debugger" },
    { "<leader>f", group = " Find" },
    { "<leader>fe", tree.tree.toggle, desc = " Project Explore" },
    { "<leader>ff", telescope.find_files, desc = " Project File" },
    { "<leader>fg", telescope.live_grep, desc = " Project Grep" },
    { "<leader>g", group = " Git" },
    { "<leader>gB", telescope.git_branches, desc = " Branches" },
    { "<leader>gb", gitsigns.blame_line, desc = " blame" },
    { "<leader>gc", telescope.git_commits, desc = " Commits" },
    { "<leader>gs", telescope.git_status, desc = " Status" },
    { "<leader>t", group = " Tools" },
    { "<leader>tl", "<cmd>Lazy<cr>", desc = " Lazy" },
    { "<leader>tm", "<cmd>Mason<cr>", desc = " Mason" },
    { "<leader>tt", "<cmd>lua require('nvim-terminal').DefaultTerminal:toggle()<cr>", desc = " Terminal" },
    { "<leader>w", group = " Window" },
    { "<leader>wh", "<cmd> split <cr>", desc = " Horisontal" },
    { "<leader>wv", "<cmd> vsplit <cr>", desc = " Vertical" },
    { "<leader>z", group = " Zettlekasten" },
    { "<leader>zf", "<cmd> ZkNotes <cr>", desc = " Find Note" },
    { "<leader>zn", "<cmd> ZkNew <cr>", desc = " New Note" },
})
