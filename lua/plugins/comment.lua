return { -- Comment with 'gc' in visual mode or block comment with 'gb', support gc operations in normal mode
	"numToStr/Comment.nvim",
	event = "BufReadPre",
	dependencies = {
		{ -- Update comment string based on treesitter
			"JoosepAlviste/nvim-ts-context-commentstring",
			init = function()
				vim.g.skip_ts_context_commentstring_module = true
			end,
			opts = { enable_autocmd = false },
		},
	},
	config = function()
		---@diagnostic disable-next-line:missing-fields
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})

		local cft = require("Comment.ft")
		cft.kdl = { "// %s", "/* %s */" }
		cft.json = { "// %s", "/* %s */" }
	end,
}
