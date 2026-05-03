--- @module 'blink-cmp'

--- @class SshConfigSource : blink.cmp.Source
--- @field completion_items blink.cmp.CompletionItem[]
local sshconfig = {}

function sshconfig.build()
	---@param message string
	local function info(message)
		vim.notify("[blink-cmp-sshconfig]: " .. message, vim.log.levels.INFO)
	end

	--- @type string[]
	local runtime_paths = vim.split(vim.o.runtimepath, ",", { plain = true })

	--- @type string
	local plugin_dir = vim.iter(runtime_paths):find(function(path)
		return vim.endswith(path, "blink-cmp-sshconfig")
	end)

	local success, result = pcall(function()
		return vim.system({ "make" }, { cwd = plugin_dir }):wait()
	end)

	-- Use pre-generated `completion_items.lua` as a fallback if vim.system
	-- throws an error or a non-zero exit code is returned.
	if (not success) or result.code ~= 0 then
		info(
			"unable to generate `completion_items.lua`, using pre-generated `completion_items.lua` instead"
		)

		local src_path = plugin_dir .. "/lua/blink-cmp-sshconfig/pre_generated_completion_items.lua"
		local dest_path = plugin_dir .. "/lua/blink-cmp-sshconfig/completion_items.lua"
		vim.uv.fs_copyfile(src_path, dest_path)

		info("`pre_generated_completion_items.lua` has been copied over as `completion_items.lua`")
	else
		info("`completion_items.lua` has been generated successfully")
	end
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
