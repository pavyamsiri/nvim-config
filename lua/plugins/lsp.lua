return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- LSP and linter manager
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        -- Useful status updates for LSP operations
        { "j-hui/fidget.nvim", opts = {} },
        -- Additional lua configuration when working with nvim
        "folke/neodev.nvim",
    },
    config = function()
        -- Toggle autoformat
        local format_is_enabled = true
        vim.api.nvim_create_user_command("ToggleFormat", function()
            format_is_enabled = not format_is_enabled
            print("Setting autoformatting to: " .. tostring(format_is_enabled))
        end, {})

        -- Create an augroup that is used for managing our formatting autocmds
        --     We need one augroup per client to make sure that multiple clients
        --     can attach to the same buffer without interfering with each other.
        local _augroups = {}
        local get_augroup = function(client)
            if not _augroups[client.id] then
                local group_name = "lsp-format-" .. client.name
                local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                _augroups[client.id] = id
            end
            return _augroups[client.id]
        end

        -- Whenever a LSP attaches to a buffer, we will run this function.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach-format", { clear = true }),
            -- This is where we attach the autoformatting
            callback = function(args)
                local client_id = args.data.client_id
                local client = vim.lsp.get_client_by_id(client_id)
                local bufnr = args.buf

                -- Only attach to clients that support formatting
                if not client.server_capabilities.documentFormattingProvider then
                    return
                end

                -- Create an autocmd that will run before we save the buffer
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = get_augroup(client),
                    buffer = bufnr,
                    callback = function()
                        -- Only run the formatter if autoformatting is enabled
                        if not format_is_enabled then
                            return
                        end

                        vim.lsp.buf.format {
                            async = false,
                            filter = function(c)
                                return c.id == client.id
                            end
                        }
                    end,
                })
            end
        })
    end
}
