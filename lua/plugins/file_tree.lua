return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
        {
            "<leader>fe",
            function()
                require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
            end,
            desc = "[f]ile [e]xplorer on current working directory"
        },
        {
            "<leader>be",
            function()
                require("neo-tree.command").execute({ toggle = true, source = "buffers" })
            end,
            desc = "[b]uffer [e]xplorer"
        }
    },
    deactivate = function()
        vim.cmd([[Neotree close]])
    end,
    init = function()
        -- Open NeoTree automatically when vim starts up on opening a directory
        if vim.fn.argc(-1) == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree")
            end
        end
    end,
    opts = {
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        filesystem = {
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
        },
        window = {
            mappings = {
                ["<space>"] = "none",
            }
        },
    },
}
