return {
  "folke/tokyonight.nvim",
  lazy=false,
  priority = 1000,
  opts = function()
    require("tokyonight").setup({
      style = "moon",
      transparent = true
    })
    -- setup must be called before loading
    vim.cmd[[colorscheme tokyonight]]
  end,
}
