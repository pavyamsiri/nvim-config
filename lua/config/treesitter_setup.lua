-- Defer loading of treesitter to after first render to improve startup time
vim.defer_fn(function()
    require("nvim-treesitter.configs").setup {
        -- NOTE: Add languages to be installed for treesitter here
        ensure_installed = {
            -- C-likes
            "c", "cpp",
            -- Scripting
            "lua", "python",
            -- Modern languages
            "rust", "zig", "go",
            -- Web
            "javascript", "typescript", "css", "html",
            -- Vim
            "vimdoc", "vim",
            -- Shell
            "bash", "fish",
            -- Git
            "gitignore", "git_config", "git_rebase", "gitattributes", "gitcommit",
            -- Graphics shaders
            "glsl", "hlsl", "wgsl",
            -- Build systems
            "cmake", "make",
            -- Data formats
            "json", "toml", "yaml", "csv", "tsv",
            -- Functional languages
            "haskell",
            -- Markup languages
            "latex", "markdown",
            -- Configs
            "ssh_config",
        },

        -- Fix indentation issue in python
        indent = {
            enable = true,
            disable = "python",
        },

        -- Autoinstall languages that are not installed
        auto_install = false,

        -- Highlighting
        highlight = {
            enable = true,
            -- Disable treesitter for some filetypes
            -- disable = { },
        },
        -- Incremental selection
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<c-space>",
                node_incremental = "<c-space>",
                scope_incremental = "<c-s>",
                node_decremental = "<M-space>",
            },
        },
        -- Text objects
        textobjects = {
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
                -- Keymaps
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                -- Whether to set jumps in the jumplist
                set_jumps = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>A"] = "@parameter.inner",
                },
            }
        }
    }
end, 0)
