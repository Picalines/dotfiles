-- Welcome to my
--
--                                                  
--    ██ █        ██       ██       █         █       ██ █
--   ███ █       ██     ██     █           █     ██ █
--  ███ █      ██ █   █  █   █            ██   ██ █
-- ███ █ ██ █ █    █ █      ██ █████
-- ██ ██ █ █  █    █ ██ █   █ ██      █
--     ███   █ █      █  █  ██ █  █   ██            █
--     ███     █      ██   █  █     █           █
--     ██       █          ██     ████       █         █
--                                                      
--
-- configuration

vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable',
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

math.randomseed(os.time())

local autocmd = require 'util.autocmd'
local persist = require 'util.persist'

pcall(persist.load)

local augroup = autocmd.group 'init'
augroup:on('ColorScheme', '*', 'doautocmd User ColorSchemeInit')
augroup:on('ColorScheme', '*', 'doautocmd User ColorSchemePatch')

pcall(require, 'plugins')
pcall(require, 'settings')
