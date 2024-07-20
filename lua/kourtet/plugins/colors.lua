function SetColorScheme(cs)
    cs = cs or "tokyonight-night"
    vim.cmd.colorscheme(cs)
end

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        config = function()
            SetColorScheme()
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    }
}
