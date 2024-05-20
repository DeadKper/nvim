return { -- Auto detection for file indentation with custom logic in lua to add default values
	"tpope/vim-sleuth",
	config = function()
		local conf = {
			ignore = { "", "text" },
			default = {
				indent = 4,
				spaces = false,
			},
			filetype = {
				lua = {
					indent = 2,
					spaces = true,
				},
			},
		}

		local function exec(cmd)
			return vim.api.nvim_exec2(cmd, { output = true }).output
		end

		local function indent(sleuth)
			if sleuth == true then
				local text = exec("Sleuth")
				if text:match("failed") then
					vim.cmd("echohl WarningMsg")
					vim.cmd("echo '" .. text .. "'")
					vim.cmd("echohl NONE")
					return
				end
			else
				if not exec("verbose set ts sw"):match("sleuth[.]vim") then
					return
				end
			end

			local tabstop = vim.fn.eval("&ts")
			local shiftwidth = vim.fn.eval("&sw")

			if shiftwidth == 0 or tabstop == shiftwidth then
				if tabstop == 8 and not vim.tbl_contains(conf.ignore, vim.bo.filetype) then
					local defaults = conf.filetype[vim.bo.filetype]
					vim.bo.tabstop = defaults and defaults.indent or conf.default.indent
					vim.bo.expandtab = defaults and defaults.spaces or conf.default.spaces
					vim.bo.shiftwidth = vim.bo.tabstop
				end
			elseif tabstop < shiftwidth then
				vim.bo.shiftwidth = tabstop
			else
				if vim.fn.eval("&et") == 1 then
					vim.bo.tabstop = shiftwidth
				end
			end

			if sleuth == true then
				print(
					":setlocal "
						.. (vim.fn.eval("&et") == 1 and "et" or "noet")
						.. (vim.fn.eval("&et") == 0 and " ts=" .. vim.fn.eval("&ts") or "")
						.. " sw="
						.. vim.fn.eval("&sw")
				)
			end
		end

		vim.api.nvim_create_user_command("Indent", function()
			indent(true)
		end, {})

		local augroup = vim.api.nvim_create_augroup("indent", { clear = true })

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufFilePost", "FileType" }, {
			group = augroup,
			callback = indent,
		})

		vim.api.nvim_create_autocmd({ "BufNewFile" }, {
			group = augroup,
			callback = function()
				indent()
				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					group = augroup,
					once = true,
					buffer = vim.api.nvim_get_current_buf(),
					callback = function()
						vim.defer_fn(vim.cmd.Indent, 500)
					end,
				})
			end,
		})
	end,
}
