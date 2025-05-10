return {
	"nmac427/guess-indent.nvim",
	config = function()
		require("guess-indent").setup({
			auto_cmd = true,
			override_editorconfig = false,
			filetype_exclude = {
				"netrw",
				"tutor",
			},
			buftype_exclude = {
				"help",
				"nofile",
				"terminal",
				"prompt",
			},
		})

		local group = vim.api.nvim_create_augroup("guess-indent-new-file", { clear = true })

		-- Run guess indent on new file after it's written for the first time
		vim.api.nvim_create_autocmd({ "BufNewFile" }, {
			group = group,
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					group = group,
					once = true,
					buffer = bufnr,
					callback = function()
						vim.defer_fn(function()
							vim.api.nvim_buf_call(bufnr, function()
								vim.cmd.GuessIndent()
							end)
						end, 1000)
					end,
				})
			end,
		})
	end,
}
