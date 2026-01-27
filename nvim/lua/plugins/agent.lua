return {
	{
		"sourcegraph/amp.nvim",
		branch = "main",
		lazy = false,
		opts = { auto_start = true, log_level = "info" },
		init = function()
			-- Send a quick message to the agent
			vim.api.nvim_create_user_command("AmpSend", function(opts)
				local message = opts.args
				if message == "" then
					print("Please provide a message to send")
					return
				end

				local amp_message = require("amp.message")
				amp_message.send_message(message)
			end, {
				nargs = "*",
				desc = "Send a message to Amp",
			})

			-- Send entire buffer contents
			vim.api.nvim_create_user_command("AmpSendBuffer", function(opts)
				local buf = vim.api.nvim_get_current_buf()
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				local content = table.concat(lines, "\n")

				local amp_message = require("amp.message")
				amp_message.send_message(content)
			end, {
				nargs = "?",
				desc = "Send current buffer contents to Amp",
			})

			-- Add selected text directly to prompt
			vim.api.nvim_create_user_command("AmpPromptSelection", function(opts)
				local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
				local text = table.concat(lines, "\n")

				local amp_message = require("amp.message")
				amp_message.send_to_prompt(text)
			end, {
				range = true,
				desc = "Add selected text to Amp prompt",
			})

			-- Add file+selection reference to prompt
			vim.api.nvim_create_user_command("AmpPromptRef", function(opts)
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname == "" then
					print("Current buffer has no filename")
					return
				end

				local relative_path = vim.fn.fnamemodify(bufname, ":.")
				local ref = "@" .. relative_path
				if opts.line1 ~= opts.line2 then
					ref = ref .. "#L" .. opts.line1 .. "-" .. opts.line2
				elseif opts.line1 > 1 then
					ref = ref .. "#L" .. opts.line1
				end

				local amp_message = require("amp.message")
				amp_message.send_to_prompt(ref)
			end, {
				range = true,
				desc = "Add file reference (with selection) to Amp prompt",
			})
		end,
	},

	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for `snacks` provider.
			---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			}

			-- Required for `opts.events.reload`.
			vim.o.autoread = true

			-- Recommended/example keymaps.
			vim.keymap.set({ "n", "x" }, "<C-a>", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask opencode" })
			vim.keymap.set({ "n", "x" }, "<C-x>", function()
				require("opencode").select()
			end, { desc = "Execute opencode action…" })
			vim.keymap.set({ "n", "t" }, "<C-.>", function()
				require("opencode").toggle()
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "go", function()
				return require("opencode").operator("@this ")
			end, { expr = true, desc = "Add range to opencode" })
			vim.keymap.set("n", "goo", function()
				return require("opencode").operator("@this ") .. "_"
			end, { expr = true, desc = "Add line to opencode" })

			vim.keymap.set("n", "<S-C-u>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "opencode half page up" })
			vim.keymap.set("n", "<S-C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "opencode half page down" })

			-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
		end,
	},
}
