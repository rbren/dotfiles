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
			vim.keymap.set("i", "<Tab>", "copilot#Accept('<CR>')", {noremap = true, silent = true, expr=true, replace_keycodes = false })
			vim.keymap.set("i", "<C-d>", 'copilot#Next()', { expr = true })
			vim.keymap.set("i", "<C-s>", 'copilot#Previous()', { expr = true })
		end,
	},
}
