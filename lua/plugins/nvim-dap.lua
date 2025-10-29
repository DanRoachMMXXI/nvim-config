return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"nvim-neotest/nvim-nio",
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
		},
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = {
				"mason-org/mason.nvim",
			},
			opts = {
				ensure_installed = { "cppdbg" },
				automatic_setup = true,
			},
			config = function(_, opts)
				require("mason").setup()
				mason_nvim_dap = require("mason-nvim-dap")
				mason_nvim_dap.setup(opts)

				local dap = require('dap')
				dap.adapters.cppdbg = {
					id = 'cppdbg',
					type = 'executable',
					command = '/home/dan/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
				}
				dap.configurations.c = {
					{
						name = "Launch file",
						type = "cppdbg",
						request = "launch",
						program = function()
							return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
						end,
						cwd = '${workspaceFolder}',
						stopAtEntry = true,
					},
					{
						name = 'Attach to gdbserver :1234',
						type = 'cppdbg',
						request = 'launch',
						MIMode = 'gdb',
						miDebuggerServerAddress = 'localhost:1234',
						miDebuggerPath = '/usr/bin/gdb',
						cwd = '${workspaceFolder}',
						program = function()
							return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
						end,
					},
				}
				dap.configurations.cpp = dap.configurations.c
				dap.configurations.rust = dap.configurations.c
			end,
		},
	},
	config = function()
		local dap = require("dap")
		local dap_ui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")

		dap_ui.setup()
		dap_virtual_text.setup()

		-- TODO: keybinds

		-- open the UI on DAP events
		dap.listeners.before.attach.dapui_config = function()
			dap_ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dap_ui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dap_ui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dap_ui.close()
		end
	end,
}
