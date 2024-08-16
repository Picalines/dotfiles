local lazy = require 'lazy'
local app = require 'util.app'
local array = require 'util.array'

local lazy_modules = {}

local function add_module(module)
	lazy_modules[#lazy_modules + 1] = module
end

app.switch {
	nvim = function()
		add_module 'plugins.nvim'
		add_module 'plugins.nvim.colorschemes'
	end,

	vscode = function()
		add_module 'plugins.vscode'
	end,

	terminal = function()
		add_module 'plugins.terminal'
	end,
}

lazy.setup(array.map(lazy_modules, function(module)
	return { import = module }
end))
