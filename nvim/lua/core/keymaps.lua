-- Shorten function name
local wk = require("which-key")
local telescope = require('telescope.builtin')
local tree = require('nvim-tree.api')
local dap = require('dap')
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
keymap("n", "n", "h", opts)
keymap("n", "e", "j", opts)
keymap("n", "i", "k", opts)
keymap("n", "o", "l", opts)

-- Window navigation
keymap("n", "<C-n>", "<C-w>h", opts)
keymap("n", "<C-e>", "<C-w>j", opts)
keymap("n", "<C-i>", "<C-w>k", opts)
keymap("n", "<C-o>", "<C-w>l", opts)


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


wk.register {
  ["<leader>"] = {
    f = {
      name = "Find",
      f = { telescope.find_files, "Project File" },
      g = { telescope.live_grep, "Project Grep" },
      e = { tree.tree.toggle, "Project Explore" }
    },
    t = {
      name = "Tools",
      l = { "<cmd>Lazy<cr>", "Lazy" },
      m = { "<cmd>Mason<cr>", "Mason" },
      t = { "<cmd>lua require('nvim-terminal').DefaultTerminal:toggle()<cr>", "Terminal" },
    },
    c = {
      name = " Code",
      d = { vim.lsp.buf.definition, "Code Definition" },
      i = { vim.lsp.buf.implementation, "Code Implementation" },
      r = { telescope.lsp_references, "Code References" }
    },
    d = {
      name = " Debug",
      b = { dap.toggle_breakpoint, "Toggle Breakpoint" }
    },
    w = {
      name = " Window",
      v = { "<cmd>vsplit<cr>", "Vertical" },
      h = { "<cmd>split<cr>", "Horisontal" }
    }
  }
}
