--- @module 'blink-cmp'

--- @class SshConfigSource : blink.cmp.Source
--- @field completion_items blink.cmp.CompletionItem[]
local sshconfig = {}

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
