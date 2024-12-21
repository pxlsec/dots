return {
	"rcarriga/nvim-dap-ui",
	dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
	event = "VeryLazy",
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup()
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
    dap.configurations.cpp = {{
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return require("xmake.project").info.target.exec_path
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        },
    }
	end,
}
