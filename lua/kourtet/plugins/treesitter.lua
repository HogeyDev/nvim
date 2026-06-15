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
            -- additional_vim_regex_highlighting = false,
        },
    },
    config = function(_, opts)
        require("nvim-treesitter").setup(opts)

        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
                if lang then
                    pcall(vim.treesitter.start)
                end
            end,
        })
    end,
}
