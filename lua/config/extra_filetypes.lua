vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.adql",
    callback = function()
        vim.bo.filetype = "sql"
    end,
})
