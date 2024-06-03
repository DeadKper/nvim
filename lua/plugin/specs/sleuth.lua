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
					spaces = false,
				},
			},
		}

		local function exec(cmd)
			local ok, res = pcall(vim.api.nvim_exec2, cmd, { output = true })
			if not ok then
				return ""
			end
			return res.output or ""
		end

		local function set_indents(indent, spaces)
			vim.bo.tabstop = indent
			vim.bo.shiftwidth = indent
			if spaces then
				vim.bo.expandtab = spaces
			end
		end

		local function detect_indent(echo)
			if vim.b.custom_sleuth ~= nil and echo ~= true then
				return
			end

			vim.b.custom_sleuth = true
			local has_default = conf.filetype[vim.bo.filetype] ~= nil

			if echo == true then
				local cmd_text = exec("Sleuth")

				if cmd_text:match("failed") and not has_default then
					vim.cmd("echohl WarningMsg")
					vim.cmd("echo '" .. cmd_text .. "'")
					vim.cmd("echohl NONE")
					return
				end
			elseif not exec("verbose set ts sw"):match("sleuth[.]vim") and not has_default then
				return
			elseif vim.tbl_contains(conf.ignore, vim.bo.filetype) then
				if echo == true then
					vim.cmd("echohl WarningMsg")
					vim.cmd("echo 'Cannot set indent for ignored filetype'")
					vim.cmd("echohl NONE")
				end

				return
			end

			local defaults = conf.filetype[vim.bo.filetype] or conf.default

			local tabstop = vim.fn.eval("&ts")
			local shiftwidth = vim.fn.eval("&sw")
			local spaces = vim.fn.eval("&et") == 1

			if shiftwidth == 0 or tabstop == shiftwidth then
				if tabstop == 8 or tabstop == conf.default.indent then -- Sleuth didn't set anything, set defaults
					set_indents(defaults.indent, defaults.spaces)
				end
			elseif tabstop < shiftwidth then
				set_indents(tabstop)
			else
				if spaces then
					set_indents(shiftwidth)
				end
			end

			spaces = vim.fn.eval("&et") == 1

			if echo == true then
				print(
					":setlocal "
						.. (spaces and "et" or "noet")
						.. (not spaces and " ts=" .. vim.fn.eval("&ts") or "")
						.. " sw="
						.. vim.fn.eval("&sw")
				)
			end
		end

		vim.api.nvim_create_user_command("Indent", function()
			detect_indent(true)
		end, {})

		local augroup = vim.api.nvim_create_augroup("indent", { clear = true })

		vim.api.nvim_create_autocmd({ "BufAdd", "BufReadPost", "BufFilePost", "FileType" }, {
			group = augroup,
			callback = detect_indent,
		})

		vim.api.nvim_create_autocmd({ "BufNewFile" }, {
			group = augroup,
			callback = function()
				detect_indent()
				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					group = augroup,
					once = true,
					buffer = vim.api.nvim_get_current_buf(),
					callback = function()
						vim.defer_fn(function()
							vim.b.custom_sleuth = true
							detect_indent()
						end, 500)
					end,
				})
			end,
		})
	end,
}
