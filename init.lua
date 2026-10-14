-- 1. Standard Sensible Defaults
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes" -- always show the sign column, so text doesn't shift
-- Show the completion menu while typing, but don't select/insert a match automatically
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true

-- 2. Bootstrap lazy.nvim (Minimal Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load TreeSitter (Fixed Version)
require("lazy").setup({
    -- The Catppuccin Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- Mocha is the darkest base flavor

                -- PURE BLACK OVERRIDES:
                -- This strips away the default dark-blue/grey panels and forces absolute black (#000000)
                color_overrides = {
                    mocha = {
                        base = "#000000",
                        mantle = "#000000",
                        crust = "#000000",
                    },
                },

                integrations = {
                    treesitter = true,
                    native_lsp = { enable = false }, -- Keeping it minimal
                }
            })

            -- Load the colorscheme
            vim.cmd.colorscheme("catppuccin")
        end,
    },{
        "nvim-treesitter/nvim-treesitter",
        lazy = false, -- Treesitter prefers to load immediately on startup
        build = ":TSUpdate",
        config = function()
            -- FIXED: Require the main module directly, not '.configs'
            local treesitter = require("nvim-treesitter")

            treesitter.setup({
                -- Add any languages you want pre-installed here
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "query", "markdown",
                    "ocaml", "ocaml_interface", "ocamllex",
                },

                -- Automatically install missing parsers when you open a new filetype
                auto_install = true,
            })
        end,
    }
})

-- 4. TreeSitter Highlighting
-- The 'main' branch of nvim-treesitter no longer enables highlighting on its
-- own, so start it for every filetype that has a parser installed.
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- 5. OCaml LSP (ocamllsp, built into the opam switch)
vim.lsp.config("ocamllsp", {
    cmd = { "ocamllsp" },
    filetypes = { "ocaml", "ocaml_interface", "ocamllex", "dune", "menhir" },
    root_markers = { "dune-project", "dune-workspace", "*.opam", ".git" },
    -- .mli files are detected as filetype "ocaml"; give them the interface id
    get_language_id = function(bufnr, ftype)
        if ftype == "ocaml"
            and vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":e") == "mli" then
            return "ocaml.interface"
        end
        return ftype
    end,
})
vim.lsp.enable("ocamllsp")

-- 6. LSP Completion + Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local buf = ev.buf
        -- ocamllsp only triggers completion after "." and "#"; add identifier
        -- characters so the menu also pops up while typing. This must happen
        -- BEFORE completion.enable() reads the trigger characters.
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local provider = client and client.server_capabilities.completionProvider
        if provider then
            local triggers = provider.triggerCharacters or {}
            local seen = {}
            for _, ch in ipairs(triggers) do seen[ch] = true end
            for ch in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"):gmatch(".") do
                if not seen[ch] then
                    triggers[#triggers + 1] = ch
                    seen[ch] = true
                end
            end
            provider.triggerCharacters = triggers
        end

        -- Menu pops up automatically, but 'noselect' (set above) means nothing
        -- is inserted until you pick an item.
        vim.lsp.completion.enable(true, ev.data.client_id, buf, { autotrigger = true })
        -- Ctrl-Space toggles the menu: opens it, or closes it if already showing
        vim.keymap.set("i", "<C-Space>", function()
            if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-e>", true, false, true), "n", false)
            else
                vim.lsp.completion.get()
            end
        end, { buffer = buf, desc = "Toggle completion" })

        -- Alt+hjkl navigates the completion menu (no-op when it isn't showing)
        --   h = close, j = next, k = previous, l = accept
        local pum = function(key)
            return function()
                return vim.fn.pumvisible() == 1 and key or ""
            end
        end
        vim.keymap.set("i", "<M-h>", pum("<C-e>"), { buffer = buf, expr = true, desc = "Completion: close" })
        vim.keymap.set("i", "<M-j>", pum("<C-n>"), { buffer = buf, expr = true, desc = "Completion: next" })
        vim.keymap.set("i", "<M-k>", pum("<C-p>"), { buffer = buf, expr = true, desc = "Completion: previous" })
        vim.keymap.set("i", "<M-l>", pum("<C-y>"), { buffer = buf, expr = true, desc = "Completion: accept" })

        -- Tab accepts the highlighted completion (same as Alt+l); plain Tab otherwise
        vim.keymap.set("i", "<Tab>", function()
            return vim.fn.pumvisible() == 1 and "<C-y>" or "<Tab>"
        end, { buffer = buf, expr = true, desc = "Completion: accept (or Tab)" })

        local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gr", vim.lsp.buf.references, "References")
        map("K", vim.lsp.buf.hover, "Hover")
        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
    end,
})

-- 7. Format on save with ocamlformat (via ocamllsp)
-- Only runs when the project has an .ocamlformat file, otherwise ocamlformat errors.
local function has_ocamlformat(bufnr)
    local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
    return vim.fs.find(".ocamlformat", { path = dir, upward = true })[1] ~= nil
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ml", "*.mli" },
    callback = function(ev)
        if not has_ocamlformat(ev.buf) then return end
        if #vim.lsp.get_clients({ bufnr = ev.buf, method = "textDocument/formatting" }) == 0 then return end
        vim.lsp.buf.format({
            async = false,
            filter = function(client) return client.name == "ocamllsp" end,
        })
    end,
})

vim.keymap.set("i", "<C-/>", "(*  *)<Esc>2hi", { silent = true })
