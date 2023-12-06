-- Turn off <C-u> and <C-d> mappings in Telescope (these are used for scrolling)
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        }
    }
}

-- Enable telescope fzf native if installed
pcall(require("telescope").load_extension, "fzf")

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's (file) path
local function find_git_root()
    -- Get the current buffer's path
    local current_path = vim.api.nvim_buf_get_name(0)

    local current_dir
    -- Current working directory
    local cwd = vim.fn.getcwd()
    -- Return nil if the buffer has no associated file
    if current_path == "" then
        current_dir = cwd
    else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_path, ":h")
    end

    -- Find the git root directory from the current file's path
    local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
    if vim.v.shell_error ~= 0 then
        print "Not a git repository. Searching on current working directory"
        return cwd
    end
    return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
        require("telescope.builtin").live_grep {
            search_dirs = { git_root },
        }
    end
end

-- Create a command to search in git root
vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- Find in recently opened files
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find in recently opened files" })
-- Find in existing buffers
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find in existing buffers" })
-- Find in current buffer (fuzzily)
vim.keymap.set("n", "<leader>/", function()
    -- NOTE: Pass additional configuration to telescope to change theme and layout
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = "[/] Find in current buffer (fuzzily)" })

-- Live grep in open files
local function telescope_live_grep_open_files()
    require("telescope.builtin").live_grep {
        grep_open_files = true,
        prompt_title = "Live grep in open files",
    }
end

-- More telescope mappings
-- Search (text) in open files
vim.keymap.set("n", "<leader>s/", telescope_live_grep_open_files, { desc = "[S]earch [/] in open files" })
-- NOTE: Not exactly sure what this does
vim.keymap.set("n", "<leader>ss", require("telescope.builtin").builtin, { desc = "[S]earch [S]elect Telescope" })
-- Search files commited to git
vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "[S]earch [G]it files" })
-- Search files
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
-- Search help
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
-- Search current word
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
-- Search by grep
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
-- Search by grep in git root (git grep)
vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<cr>", { desc = "[S]earch by [G]rep on git root" })
-- Search diagnostics
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
-- Search resume
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
