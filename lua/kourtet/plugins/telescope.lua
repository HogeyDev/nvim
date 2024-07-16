return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep",
    },
    config = function()
        vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
        vim.keymap.set("n", "<leader>fw", require("telescope.builtin").live_grep)
        vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics)
        vim.keymap.set("n", "<leader>fa", require("telescope.builtin").buffers)

        local actions = require("telescope.actions")
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = {
                        ["<M-j>"] = actions.move_selection_next,
                        ["<M-k>"] = actions.move_selection_previous,
                    }
                }
            }
        })
    end,
}
