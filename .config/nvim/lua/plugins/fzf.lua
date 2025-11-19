return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({ "default-title" })

    -- Keymaps
    local fzf = require("fzf-lua")
    local map = vim.keymap.set
    
    -- File pickers
    map("n", "<leader>ff", fzf.files, { desc = "Find Files" })
    map("n", "<leader>fg", fzf.git_files, { desc = "Find Git Files" })
    map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
    map("n", "<leader>fb", fzf.buffers, { desc = "Find Buffers" })
    
    -- Search
    map("n", "<leader>fw", fzf.grep_cword, { desc = "Find Word under Cursor" })
    map("n", "<leader>fs", fzf.live_grep, { desc = "Live Grep" })
    map("v", "<leader>fs", fzf.grep_visual, { desc = "Grep Visual Selection" })
    
    -- LSP
    map("n", "<leader>fd", fzf.lsp_document_symbols, { desc = "Document Symbols" })
    
    -- Git
    map("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
    map("n", "<leader>gS", fzf.git_status, { desc = "Git Status" })
    
    -- Vim
    map("n", "<leader>fh", fzf.help_tags, { desc = "Help Tags" })
  end,
}
