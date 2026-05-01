function SetColorScheme(cs)
    cs = cs or "tokyonight-night"
    vim.cmd.colorscheme(cs)
end

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        config = function()
            SetColorScheme("tokyonight-night")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    {
        "morhetz/gruvbox",
        name = "gruvbox",
    },
    {
        "loctvl842/monokai-pro.nvim",
        name = "monokai-pro",
    },
    {
        "mofiqul/dracula.nvim",
        name = "dracula",
    },
    {
        "gbprod/nord.nvim",
        name = "nord",
    },
}
