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
				kdl = {
					indent = 2,
					spaces = false,
				},
				javascript = {
					indent = 2,
					spaces = false,
				},
				typescript = {
					indent = 2,
					spaces = false,
				},
			},
		}

		local function exec(cmd)
			return vim.api.nvim_exec2(cmd, { output = true }).output
		end

		---@param sleuth boolean
		---@return number was_set
		local function check_sleuth(sleuth)
			if sleuth == true then
				local text = exec("Sleuth")
				if text:match("failed") then
					return 1
				end
			else
				if not exec("verbose set ts sw"):match("sleuth[.]vim") then
					return 2
				end
			end

			local tabstop = vim.fn.eval("&ts")
			local shiftwidth = vim.fn.eval("&sw")

			if shiftwidth == 0 or tabstop == shiftwidth then
				if (tabstop == 8 or tabstop == conf.default.indent) and not vim.tbl_contains(conf.ignore, vim.bo.filetype) then
					local defaults = conf.filetype[vim.bo.filetype] or conf.default
					vim.bo.tabstop = defaults.indent
					vim.bo.shiftwidth = defaults.indent
					vim.bo.expandtab = defaults.spaces
				end
			elseif tabstop < shiftwidth then
				vim.bo.shiftwidth = tabstop
			else
				if vim.fn.eval("&et") == 1 then
					vim.bo.tabstop = shiftwidth
				end
			end

			return 0
		end

		local function indent(use_sleuth)
			local res = check_sleuth(use_sleuth)
			if res ~= 0 and vim.bo.filetype and conf.filetype[vim.bo.filetype] then
				local defaults = conf.filetype[vim.bo.filetype] or conf.default
				vim.bo.tabstop = defaults.indent
				vim.bo.shiftwidth = defaults.indent
				vim.bo.expandtab = defaults.spaces
				res = 0
			end

			if use_sleuth == true then
				if res == 0 then
					print(
						":setlocal "
							.. (vim.fn.eval("&et") == 1 and "et" or "noet")
							.. (vim.fn.eval("&et") == 0 and " ts=" .. vim.fn.eval("&ts") or "")
							.. " sw="
							.. vim.fn.eval("&sw")
					)
				elseif res == 1 then
					vim.cmd("echohl WarningMsg")
					vim.cmd("echo ':Sleuth failed to detect indent settings'")
					vim.cmd("echohl NONE")
				end
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
				indent(false)
				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					group = augroup,
					once = true,
					buffer = vim.api.nvim_get_current_buf(),
					callback = function()
						vim.defer_fn(function()
							indent(false)
						end, 500)
					end,
				})
			end,
		})
	end,
}
