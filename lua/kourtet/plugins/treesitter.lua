return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- branch = "main",
    -- main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = { "c", "lua", "vim", "go" },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
