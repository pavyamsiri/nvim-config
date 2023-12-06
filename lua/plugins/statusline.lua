return {
    -- Use lua line as the status line
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            -- NOTE: In the original config this was false. Not sure what it does.
            icons_enabled = true,
            theme = "gruvbox",
            component_separators = "|",
            section_separators = "",
        }
    }
}
