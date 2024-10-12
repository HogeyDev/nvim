return {
    {
        "numToStr/Comment.nvim",
        opts = {},
        config = function()
            require("Comment").setup({
                padding = true,
                sticky = true,
                ignore = nil,
                toggler = {
                    line = '<leader>/',
                },
                mappings = {
                    basic = true,
                },
                pre_hook = nil,
                post_hook = nil,
            }
            )
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        config = function()
            require("todo-comments").setup()
            vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>")
        end
    },
}
