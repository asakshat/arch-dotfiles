return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  build = ":MasonUpdate",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      },
      border = "rounded",
    },
      ensure_installed = {
      "lua_ls",
      "gopls",
      "jdtls",
      "ts_ls", -- typescript-language-server
      "cssls", -- css-lsp
      "tailwindcss", -- tailwindcss-language-server
      "clangd",
      "dockerls", -- dockerfile-language-server
      "html",
      "jsonls", -- json-lsp
      "yamlls", -- yaml-language-server
    },
    automatic_installation = true,
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    
    -- Trigger FileType event after package installation
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        require("lazy.core.handler.event").trigger({
          event = "FileType",
          buf = vim.api.nvim_get_current_buf(),
        })
      end, 100)
    end)
  end,
}
