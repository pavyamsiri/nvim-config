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

-- Register normal mode mappings for which-key
require("which-key").register {
    ["<leader>c"] = { name = "[c]ode", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "[d]ocument", _ = "which_key_ignore" },
    ["<leader>g"] = { name = "[g]it", _ = "which_key_ignore" },
    ["<leader>h"] = { name = "git [h]unk", _ = "which_key_ignore" },
    ["<leader>r"] = { name = "[r]ename", _ = "which_key_ignore" },
    ["<leader>s"] = { name = "[s]earch", _ = "which_key_ignore" },
    ["<leader>t"] = { name = "[t]oggle", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "[w]orkspace", _ = "which_key_ignore" },
}

-- Register visual mode mappings for which-key
require("which-key").register({
    ["<leader>"] = { name = "VISUAL <leader>" },
    ["<leader>h"] = { name = "git [h]unk", _ = "which_key_ignore" },
}, { mode = "v" })

-- Mason lsp config requires that setup is called in this order
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
local servers = {
    clangd = {},
    gopls = {},
    pyright = {},
    rust_analyzer = {},
    ruff_lsp = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        }
    },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities so need to broadcast that to the servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}
-- Setup handlers
mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            -- Attach the capabilities to the server
            capabilities = capabilities,
            -- Run the on_attach function for all servers
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes,
        }
    end,
}

-- Configure nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}

cmp.setup {
    snipper = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s", }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s", }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }
}