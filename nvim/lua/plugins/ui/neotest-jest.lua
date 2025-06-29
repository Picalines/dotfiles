return {
	'nvim-neotest/neotest-jest',

	lazy = true,
	dependencies = { 'nvim-neotest/neotest' },

	neotest_adapter = function()
		-- NOTE: some time ago i worked in a team where we had separate jest
		-- configs for client and server testing. I was crazy back then and
		-- wrote a giant script that opened a telescope file picker to choose
		-- correct jest configs for each suite

		-- if I encounter something similar in the future I'll probably write a
		-- heuristic like "if a suite starts with client/, try scripts like
		-- unit:client"

		return require 'neotest-jest' {}
	end,
}
