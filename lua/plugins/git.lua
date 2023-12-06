return {
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",

    {
        -- Add git related info to the gutter
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            -- On attach we need to set up some mappings
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                -- Go to next hunk
                map({ "n", "v" }, "]c", function()
                    -- Pass on the keypress if we can't go to the next hunk
                    if vim.wo.diff then
                        return "]c"
                    end
                    -- Otherwise we need to jump to the next hunk
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    -- And return something that won't be mapped
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to next hunk" })

                -- Got to previous hunk
                map({ "n", "v" }, "[c", function()
                    -- Pass on the keypress if we can't go to the next hunk
                    if vim.wo.diff then
                        return "[c"
                    end
                    -- Otherwise we need to jump to the next hunk
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    -- And return something that won't be mapped
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to previous hunk" })

                -- Actions

                -- Visual mode
                -- Stage hunk selected in visual mode
                map("v", "<leader>hs", function()
                    gs.stage_hunk { vim.fn.line ".", vim.fin.line "v" }
                end, { desc = "stage hunk (Git)" })

                -- Reset hunk selected in visual mode
                map("v", "<leader>hr", function()
                    gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
                end, { desc = "Reset hunk (Git)" })

                -- Normal mode
                -- Stage hunk
                map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk (Git)" })
                -- Reset hunk
                map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk (Git)" })
                -- Stage buffer
                map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer (Git)" })
                -- Undo stage hunk
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk (Git)" })
                -- Reset buffer
                map("n", "<leader>hR", gs.reset_buffer, { desc = "Stage hunk (Git)" })
                -- Preview hunk
                map("n", "<leader>hp", gs.preview_hunk, { desc = "Stage hunk (Git)" })
                -- Git blame
                map("n", "<leader>hb", function()
                    gs.blame_line { full = false }
                end, { desc = "Blame line (Git)" })
                -- Git diff
                map("n", "<leader>hd", gs.diffthis, { desc = "Diff line against index (Git)" })
                -- Git diff against last commit
                map("n", "<leader>hD", function()
                    gs.diffthis "~"
                end, { desc = "Diff line against last commit (Git)" })

                -- Toggles
                -- Toggle current line blame
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle current line blame (Git)" })
                -- Toggle show deleted
                map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle show deleted (Git)" })

                -- Text object
                -- NOTE: Not sure what this does
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk (Git)" })
            end,
        }
    },
}
