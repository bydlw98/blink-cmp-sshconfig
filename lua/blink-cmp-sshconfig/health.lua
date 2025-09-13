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

	local completion_items_file = "lua/blink-cmp-sshconfig/completion_items.lua"
	if vim.fn.empty(vim.fn.globpath(vim.o.rtp, completion_items_file)) == 1 then
		vim.health.error(
			"`completion_items.lua` not found",
			"Run `make` to generate `completion_items.lua`"
		)
	else
		vim.health.ok("`completion_items.lua` found")
	end
end

local M = {}

function M.check()
	check_install()
end

return M
