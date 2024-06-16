local bufnr = vim.api.nvim_get_current_buf()
local nmap = function(keys, func, desc)
    if desc then
        desc = "LSP: " .. desc
    end
    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
end

nmap("<leader>ca", function()
    vim.cmd.RustLsp("codeAction")
end, "[c]ode [a]ction")
nmap("<leader>rme", function()
    vim.cmd.RustLsp("expandMacro")
end, "[r]ust [m]acro [e]xpand")
nmap("<leader>rk", function()
    vim.cmd.RustLsp { "moveItem", "up" }
end, "[r]ust move item up [k]")
nmap("<leader>rj", function()
    vim.cmd.RustLsp { "moveItem", "down" }
end, "[r]ust move item down [j]")
nmap("<leader>re", function()
    vim.cmd.RustLsp("explainError")
end, "[r]ust [e]xplain error")
nmap("<leader>rd", function()
    vim.cmd.RustLsp("renderDiagnostic")
end, "[r]ust render [d]iagnostic")
nmap("<leader>rd", function()
    vim.cmd.RustLsp("renderDiagnostic")
end, "[r]ust render [d]iagnostic")
nmap("<leader>gC", function()
    vim.cmd.RustLsp("openCargo")
end, "[g]o to [C]argo.toml")
nmap("<leader>gp", function()
    vim.cmd.RustLsp("parentModule")
end, "[g]o to [p]arent module")
