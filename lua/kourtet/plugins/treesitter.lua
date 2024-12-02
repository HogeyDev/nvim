return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.parsers").get_parser_configs().ignis = {
          install_info = {
            url = "/home/kourtet/Programming/tree-sitter-ignis", -- Path to your parser directory
            files = { "src/parser.c" }, -- Specify parser files
            -- generate_requires_npm = false, -- Disable npm requirement
            -- requires_generate_from_grammar = false, -- Skip grammar.js compilation
          },
          filetype = "ignis", -- Set filetype for your language
          -- dynamic_loading = true,
        }
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "ignis" },
            highlight = {
                enable = true,
            },
        })
    end,
}
