-- Ported .vimrc section from Kernelnewbies
vim.opt.title = true
-- syntax is on by default

vim.opt.tabstop = 8
vim.opt.softtabstop = 8
vim.opt.shiftwidth = 8

-- Ported personal .vimrc section
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.rtp:append('/usr/bin/fzf')

require("config.lazy")
require("lazy").update({	-- test auto-update
	show = false,
})

-- Primary lsp configuration is managed in
-- ~/.config/nvim/pack/nvim/start/nvim-lspconfig
-- from this repo:
-- https://github.com/neovim/nvim-lspconfig

-- still need to manually enable the desired language servers
vim.lsp.enable('clangd')
vim.lsp.enable('svls')
vim.lsp.enable('texlab')

-- vim.lsp.completion.get() is how you use autocompletion
-- the below vim.keymap.set binds it to ctrl + space
-- vim.keymap.set('i', '<c-space>', function()
-- 	vim.lsp.completion.get()
-- end)

vim.diagnostic.config({
	virtual_text = true	-- displays diagnostic messages inline
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- set keymaps for lsp functions
		local opts = { buffer = ev.buffer }
		vim.keymap.set('n', 'gd', function()
			local splitright = vim.opt.splitright	-- store previous splitright value
			vim.opt.splitright = true	-- set splitright, making the new window open up on the right

			vim.cmd([[ vsplit ]])
			vim.lsp.buf.definition()

			vim.opt.splitright = splitright	-- restore old splitright value
		end, opts)
	end,
})
