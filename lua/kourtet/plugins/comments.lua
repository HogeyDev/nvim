return {
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
}
