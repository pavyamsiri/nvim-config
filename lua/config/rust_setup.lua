local on_attach = function(_, bufnr)
    -- Set up mappings

    -- Helper function for normal mode mappings
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Rename
    nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
    -- Code actions
    nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ction")

    -- Go to definition
    nmap("gd", require("telescope.builtin").lsp_definitions, "[g]o to [d]efinition")
    -- Go to referencees
    nmap("gr", require("telescope.builtin").lsp_references, "[g]o to [r]eferences")
    -- Go to implementation
    nmap("gi", require("telescope.builtin").lsp_implementations, "[g]o to [i]mplementation")
    -- Go to type definition
    nmap("gt", require("telescope.builtin").lsp_type_definitions, "[g]o to [t]ype definition")
    -- List symbols in current document
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[d]ist [s]ymbols")
    -- List symbols in current workspace
    nmap("<leader>ws", require("telescope.builtin").lsp_workspace_symbols, "[w]orkspace [s]ymbols")

    -- Hover documentation
    nmap("K", vim.lsp.buf.hover, "Hover documentation")
    -- Show signature help
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature documentation")

    -- Lesser used LSP functionality
    -- Go to declaration
    nmap("gD", vim.lsp.buf.declaration, "[g]o to [D]eclaration")
    -- Add workspace folder
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[w]orkspace [a]dd folder")
    -- Remove workspace folder
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[w]orkspace [r]emove folder")
    -- List workspace folders
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[w]orkspace [l]ist folders")

    -- Format buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        vim.lsp.buf.format()
    end, { desc = "Format current buffer with LSP" })
end

vim.g.rustaceanvim = {
    -- LSP configuration
    server = {
        on_attach = on_attach,
    },
}
