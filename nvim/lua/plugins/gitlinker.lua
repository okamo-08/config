return {
	"ruifm/gitlinker.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		mappings = nil, -- キーマップは自分で設定
	},
	config = function()
		require("gitlinker").setup()
		vim.keymap.set("n", "<leader>gy", function()
			require("gitlinker").get_buf_range_url("n")
		end, { desc = "Copy GitHub URL to clipboard" })

		vim.keymap.set("v", "<leader>gy", function()
			require("gitlinker").get_buf_range_url("v")
		end, { desc = "Copy GitHub URL for selection" })
	end,
}
