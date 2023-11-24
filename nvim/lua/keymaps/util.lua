local M = {}

function M.cmds(...)
	local cmds = { ... }
	return function()
		for _, cmd in pairs(cmds) do
			vim.cmd(cmd)
		end
	end
end

function M.declare_keymaps(maps)
	local base_opts = maps.opts or {}
	maps.opts = nil

	for mode, mode_maps in pairs(maps) do
		for lhs, map in pairs(mode_maps) do
			local rhs, opts

			if type(map) == 'table' then
				rhs = map[1]
				opts = map
				opts.desc = opts[2] or opts.desc
				opts[1] = nil
				opts[2] = nil
			else
				rhs = map
				opts = {}
			end

			opts = vim.tbl_extend('force', base_opts, opts)

			vim.keymap.set(mode, lhs, rhs, opts)
		end
	end
end

return M
