--- @module 'blink-cmp'

--- @class SshConfigSource : blink.cmp.Source
--- @field completion_items blink.cmp.CompletionItem[]
local sshconfig = {}

function sshconfig.build()
	local runtime_paths = vim.split(vim.o.runtimepath, ",", { plain = true })
	local plugin_dir = vim.iter(runtime_paths):find(function(path)
		return vim.endswith(path, "blink-cmp-sshconfig")
	end)

	vim.system({ "make" }, { cwd = plugin_dir }):wait()
	vim.notify(
		"[blink-cmp-sshconfig]: `completion_items.lua` has been generated",
		vim.log.levels.INFO
	)
end

function sshconfig.new()
	return setmetatable(
		{ completion_items = require("blink-cmp-sshconfig.completion_items") },
		{ __index = sshconfig }
	)
end

function sshconfig:enabled()
	return vim.bo.filetype == "sshconfig"
end

function sshconfig:get_completions(_, callback)
	callback({
		is_incomplete_forward = false,
		is_incomplete_backward = false,
		items = self.completion_items,
	})
	return function() end
end

return sshconfig
