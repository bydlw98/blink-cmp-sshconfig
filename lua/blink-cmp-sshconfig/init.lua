--- @module 'blink-cmp'

--- @class blink-cmp-sshconfig.Options
--- @field prefer_pre_generated? boolean use pre-generated `completion_items.lua` instead of generating `completion_items.lua`

--- @class SshConfigSource : blink.cmp.Source
--- @field completion_items blink.cmp.CompletionItem[]
local sshconfig = {}

--- @param prefer_pre_generated boolean use pre-generated `completion_items.lua` instead of generating `completion_items.lua`
function sshconfig.build(prefer_pre_generated)
	---@param message string
	local function info(message)
		vim.notify("[blink-cmp-sshconfig]: " .. message, vim.log.levels.INFO)
	end

	--- @param plugin_dir string
	local function use_pre_generated_completion_items(plugin_dir)
		local src_path = plugin_dir .. "/lua/blink-cmp-sshconfig/pre_generated_completion_items.lua"
		local dest_path = plugin_dir .. "/lua/blink-cmp-sshconfig/completion_items.lua"
		vim.uv.fs_copyfile(src_path, dest_path)

		info("`pre_generated_completion_items.lua` has been copied over as `completion_items.lua`")
	end

	--- @type string[]
	local runtime_paths = vim.split(vim.o.runtimepath, ",", { plain = true })

	--- @type string
	local plugin_dir = vim.iter(runtime_paths):find(function(path)
		return vim.endswith(path, "blink-cmp-sshconfig")
	end)

	if prefer_pre_generated then
		use_pre_generated_completion_items(plugin_dir)
	else
		local success, result = pcall(function()
			return vim.system({ "make" }, { cwd = plugin_dir }):wait()
		end)

		-- Use pre-generated `completion_items.lua` as a fallback if vim.system
		-- throws an error or a non-zero exit code is returned.
		if (not success) or result.code ~= 0 then
			info(
				"unable to generate `completion_items.lua`, using pre-generated `completion_items.lua` instead"
			)
			use_pre_generated_completion_items(plugin_dir)
		else
			info("`completion_items.lua` has been generated successfully")
		end
	end
end

--- @param opts? blink-cmp-sshconfig.Options
function sshconfig.new(opts)
	if vim.fn.has("nvim-0.11") == 1 then
		vim.validate("opts", opts, "table", true, "blink-cmp-sshconfig.Options")
	end
	opts = opts or {}

	if opts.prefer_pre_generated == nil then
		opts.prefer_pre_generated = true
	end

	local has_completion_items, _ = pcall(require, "blink-cmp-sshconfig.completion_items")
	if not has_completion_items then
		sshconfig.build(opts.prefer_pre_generated)
	end

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
