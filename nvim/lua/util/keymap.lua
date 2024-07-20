local M = {}

function M.declare(declaration)
	local base_opts = declaration.opts or {}
	declaration.opts = nil

	for section_key, keymaps in pairs(declaration) do
		local modes = {}
		local section_opts = {}

		if type(section_key) ~= 'table' then
			section_key = { section_key }
		end

		for opt_key, opt_value in pairs(section_key) do
			if type(opt_key) == 'string' then
				section_opts[opt_key] = opt_value
			else
				modes[opt_key] = opt_value
			end
		end

		for lhs, keymap in pairs(keymaps) do
			local rhs, map_opts

			if type(keymap) == 'table' then
				rhs = keymap[1]
				map_opts = keymap
				map_opts.desc = map_opts[2] or map_opts.desc
				map_opts[1] = nil
				map_opts[2] = nil
			else
				rhs = keymap
				map_opts = {}
			end

			local opts = vim.tbl_extend('force', base_opts, section_opts, map_opts)

			if type(lhs) ~= 'table' then
				lhs = { lhs }
			end

			for _, lhs_i in ipairs(lhs) do
				local ok = pcall(vim.keymap.set, modes, lhs_i, rhs, opts)
				if not ok then
					local lhs_s = tostring(lhs_i)
					local modes_s = table.concat(modes, ',')
					print('failed map `' .. lhs_s .. '` in ' .. modes_s)
				end
			end
		end
	end
end

return M
