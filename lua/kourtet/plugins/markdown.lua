return {
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        opts = {
            heading = { sign = false },
            bullet = { icons = { '•', '◦', '▪', '▫' } },
            anti_conceal = {
                enabled = false,
            },
        },
        config = function(_, opts)
            require('render-markdown').setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "markdown",
                callback = function()
                    vim.opt_local.wrap = true
                    vim.opt_local.linebreak = true
                    vim.opt_local.breakindent = true
                    vim.opt_local.conceallevel = 2
                    vim.opt_local.concealcursor = "nc" -- can also use v for visual and i for insert mode
                end,
            })
        end,
    },

    -- {
    --     "folke/twilight.nvim",
    --     opts = {
    --         context = 10,
    --         dimming = { alpha = 0.25 }
    --     }
    -- },

    {
        "folke/zen-mode.nvim",
        -- dependencies = { "folke/twilight.nvim" },
        keys = {
            { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
        },
        opts = {
            window = {
                width = 80,
                options = {
                    number = false,
                    relativenumber = false,
                    signcolumn = "no",
                    foldcolumn = "0",
                }
            },
            plugins = {
                -- twilight = { enabled = true },
                tmux = { enabled = true },
                kitty = {
                    enabled = true,
                    font = "+4",
                },
            }
        }
    }
}
