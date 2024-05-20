return { -- Better folds
	"kevinhwang91/nvim-ufo",
	dependencies = {
		"kevinhwang91/promise-async", -- Required
	},
	init = function()
		require("plugin.confs.lspconfig").add_capabilities({ -- Add folding capabilities
			textDocument = {
				foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
			},
		})
	end,
	config = function()
		require("plugin.confs.lspconfig").add_callback(function() -- Setup ufo after lspconfig is setup
			local ufo = require("ufo")
			vim.keymap.set("n", "zR", ufo.openAllFolds)
			vim.keymap.set("n", "zM", ufo.closeAllFolds)
			vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "Fold preview" })

			vim.opt.foldlevel = 99
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				group = vim.api.nvim_create_augroup("foldlevel", { clear = true }),
				callback = function()
					vim.opt_local.foldlevel = 99
				end,
			})

			local icons = require("config.icons")

			local function handler(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (" %s %d "):format(icons.fold.folded, endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end

			local filetypes = {
				vim = { "indent" },
				python = { "indent" },
				git = "",
			}
			---@diagnostic disable-next-line:missing-fields
			ufo.setup({
				fold_virt_text_handler = handler,
				---@diagnostic disable-next-line:unused-local
				provider_selector = function(bufnr, filetype, buftype)
					return filetypes[filetype] or { "lsp", "indent" }
				end,
				preview = {
					win_config = {
						border = { "", "", "", "", "", "", "", "" },
					},
				},
			})
		end)
	end,
}
