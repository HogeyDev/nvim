return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep",
    },
    config = function()
        vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
        vim.keymap.set("n", "<leader>fw", require("telescope.builtin").live_grep)
    end,
}
