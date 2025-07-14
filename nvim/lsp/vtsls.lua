local language_opts = {
	inlayHints = {
		includeInlayParameterNameHints = 'all',
		includeInlayParameterNameHintsWhenArgumentMatchesName = false,
		includeInlayFunctionParameterTypeHints = false,
		includeInlayVariableTypeHints = false,
		includeInlayPropertyDeclarationTypeHints = false,
		includeInlayFunctionLikeReturnTypeHints = false,
		includeInlayEnumMemberValueHints = true,
	},
}

return {
	settings = {
		completions = {
			completeFunctionCalls = true,
		},

		typescript = language_opts,
		javascript = language_opts,
	},

	handlers = {
		['textDocument/publishDiagnostics'] = function(_, result, ctx)
			if result.diagnostics == nil then
				return
			end

			local formatTsErrors = require 'format-ts-errors'

			-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
			local ignored_codes = { [80001] = true }

			for _, entry in pairs(result.diagnostics) do
				if not ignored_codes[entry.code] then
					local formatter = formatTsErrors[entry.code] or function()
						return entry.message
					end

					local ok, new_message = pcall(formatter, entry.message)
					if ok then
						entry.message = new_message
					else
						vim.notify('format-ts-errors: ' .. tostring(new_message), vim.log.levels.ERROR)
					end
				end
			end

			vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
		end,
	},
}
