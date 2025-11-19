return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            local configs = require("nvim-treesitter.configs")
            ---@diagnostic disable-next-line: missing-fields
            configs.setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                        },
                    },
                },
                -- enable syntax highlighting
                highlight = {
                    enable = true,
                },
                -- enable indentation
                indent = { enable = true },
                -- ensure these language parsers are installed
                ensure_installed = {
                    "json",
                    "javascript",
                    "typescript",
                    "tsx",
                    "html",
                    "yaml",
                    "css",
                   "bash",
                    "lua",
                    "c",
                    "gitignore",
                    "dockerfile",
                    "cpp",
                    "go",
                    "java",
                    "cpp",
                     "templ"
                },
                -- auto install above language parsers
                auto_install = true,
            })
        end
    }
}
