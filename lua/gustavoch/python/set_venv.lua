-- Function to find the project root directory (with .git or .venv)
function get_python_venv()
    local current_dir = vim.fn.getcwd()

    -- Search upwards for a .venv directory
    while current_dir ~= "/" do
        local venv_path = current_dir .. "/.venv/bin/python"
        if vim.fn.filereadable(venv_path) == 1 then
            return venv_path
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end

    -- Fallback to system python if no .venv is found
    return nil
end

-- Set Python3 interpreter for Neovim
local venv_python = get_python_venv()
if venv_python then
    vim.g.python3_host_prog = venv_python
else
    vim.g.python3_host_prog = "/usr/bin/python3" -- Fallback if no venv is found
end
