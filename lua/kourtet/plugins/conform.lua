return {
    "stevearc/conform.nvim",
    opts = function(_, opts)
        opts.formatters_by_ft = opts.formatters_by_ft or {}

        local clang_format_ft = { "c", "cpp", "objc", "cuda", "hpp", "h" }
        for _, ft in ipairs(clang_format_ft) do
            opts.formatters_by_ft[ft] = { "clang-format" }
        end

        opts.format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        }
    end,
}
