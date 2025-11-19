return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    -- Get blink.cmp capabilities
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- LSP keymaps (only loaded when LSP attaches)
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('gd', require('fzf-lua').lsp_definitions, 'Goto Definition')
        map('gi', require('fzf-lua').lsp_implementations, 'Goto Implementation')
        map('gr', require('fzf-lua').lsp_references, 'Goto References')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('<leader>qf', vim.diagnostic.setloclist, 'Quickfix Diagnostics')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        -- Toggle inlay hints if supported
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, 'Toggle Inlay Hints')
        end
      end,
    })

    -- Mason LSP config
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
      },
    })
  end,
}
