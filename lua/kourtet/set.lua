vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.winborder = "rounded"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.cmdheight = 0
vim.opt.cursorline = true


-- vim.highlight.priorities.semantic_tokens = 95

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("kourtet-highlighting-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.filetype.add({
    extension = {
        is = "ignis",
    },
})

vim.g.zig_fmt_autosave = 0

vim.filetype.add({
    extension = { ebnf = "ebnf", bnf = "ebnf" }
})

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

local markdown_numbers = vim.api.nvim_create_augroup("MarkdownDynamicNumbers", { clear = true })

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    group = markdown_numbers,
    callback = function()
        if vim.bo.filetype == "markdown" then
            vim.opt_local.number = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
    group = markdown_numbers,
    callback = function()
        if vim.bo.filetype == "markdown" then
            vim.opt_local.number = false
        end
    end,
})
