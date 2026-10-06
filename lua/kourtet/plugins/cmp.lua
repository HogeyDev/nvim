return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        -- "hrsh7th/cmp-buffer",
        -- "hrsh7th/cmp-cmdline",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            completion = { completeopt = "menu,menuone,noinsert" },
            view = {
                docs = { auto_open = false }
            },
            window = {
                completion = cmp.config.window.bordered({ max_height = 16 }),
                documentation = cmp.config.window.bordered(),
            },
            mapping = {
                ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<M-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<M-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),

                ["<C-Space>"] = function()
                    if cmp.visible() then
                        cmp.close()
                    else
                        cmp.complete()
                    end
                end,

                ["<M-h>"] = function() cmp.close_docs() end,
                ["<M-l>"] = function() cmp.open_docs() end,
            },

            sources = {
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
            }
        })
    end,
}
