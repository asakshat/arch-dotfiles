return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = true,
        },
        prompt_func_param_type = {
          go = true,
        },
        show_success_message = true,
      })
      
      -- IMPORTANT: Keymaps MUST use { expr = true } and return the refactor function
      local map = vim.keymap.set
      
      -- Extract Function (visual mode only)
      map("x", "<leader>re", function() 
        return require('refactoring').refactor('Extract Function') 
      end, { expr = true, desc = "Extract to function" })
      
      -- Extract Function to File (visual mode only)
      map("x", "<leader>rf", function() 
        return require('refactoring').refactor('Extract Function To File') 
      end, { expr = true, desc = "Extract to file" })
      
      -- Extract Variable (visual mode only)
      map("x", "<leader>rv", function() 
        return require('refactoring').refactor('Extract Variable') 
      end, { expr = true, desc = "Extract variable" })
      
      -- Inline Variable (normal and visual mode)
      map({ "n", "x" }, "<leader>ri", function() 
        return require('refactoring').refactor('Inline Variable') 
      end, { expr = true, desc = "Inline variable" })
      
      -- Inline Function (normal mode)
      map("n", "<leader>rI", function() 
        return require('refactoring').refactor('Inline Function') 
      end, { expr = true, desc = "Inline function" })
      
      -- Extract Block (visual mode, Go-specific)
      map("x", "<leader>rb", function() 
        return require('refactoring').refactor('Extract Block') 
      end, { expr = true, desc = "Extract block" })
      
      -- Extract Block to File (visual mode, Go-specific)
      map("x", "<leader>rbf", function() 
        return require('refactoring').refactor('Extract Block To File') 
      end, { expr = true, desc = "Extract block to file" })
      
      -- Refactor menu - shows all available refactors
      map({ "x", "n" }, "<leader>rr", function()
        require('refactoring').select_refactor()
      end, { desc = "Select refactor" })
      
      -- Debug helpers
      map("x", "<leader>rp", function()
        require('refactoring').debug.printf({ below = false })
      end, { desc = "Debug: printf" })
      
      map("n", "<leader>rP", function()
        require('refactoring').debug.print_var({ normal = true })
      end, { desc = "Debug: print var" })
      
      map("n", "<leader>rc", function()
        require('refactoring').debug.cleanup({})
      end, { desc = "Debug: cleanup" })
    end,
  },
}
