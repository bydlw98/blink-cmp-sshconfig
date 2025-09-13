--- @param executable string
local function check_executable(executable)
	if vim.fn.executable(executable) == 0 then
		local msg = string.format(
			"`%s` executable not found (required for generating completion items)",
			executable
		)

		vim.health.error(msg)
	else
		--- @type string
		local version = vim.system({ executable, "--version" }, { text = true }):wait().stdout
		version = vim.split(version, "\n")[1]

		local msg = string.format("`%s` executable found: `%s`", executable, version)
		vim.health.ok(msg)
	end
end

local function check_install()
	vim.health.start("Installation")

	check_executable("make")
	check_executable("uv")
end

local M = {}

function M.check()
	check_install()
end

return M
