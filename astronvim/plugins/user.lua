return {
  {
		"github/copilot.vim",
		event = "VeryLazy",

		init = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
		end,
		config = function()
			vim.keymap.set("i", "<C-f>", 'copilot#Accept("<CR>")', { expr = true })
		end,
	},
}
