return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local xmake_component = {
      function()
        local xmake = require("xmake.project").info
        if xmake.target.tg == "" then
            return ""
        end
        return xmake.target.tg .. "(" .. xmake.mode .. ")"
      end,

      cond = function()
        return vim.o.columns > 100
      end,

      on_click = function()
        require("xmake.project._menu").init() -- Add the on-click ui
      end,
      }

      require("lualine").setup({
        sections = {
          lualine_y = {
            xmake_component
          }
        }
      })
    end
}
