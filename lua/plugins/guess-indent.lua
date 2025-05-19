return {
	"nmac427/guess-indent.nvim",
	config = function()
		---@type GuessIndentConfig
		local opts = {
			filetype_exclude = {
				"oil",
				"netrw",
				"tutor",
			},
			buftype_exclude = {
				"help",
				"nofile",
				"terminal",
				"prompt",
			},
		}

		local defaults = {
			{
				ft = { "yaml", "yaml.ansible" },
				expandtab = true,
				shiftwidth = 2,
			},
			{
				ft = { "sh", "bash", "zsh" },
				expandtab = false,
				shiftwidth = 4,
			},
			{
				ft = "lua",
				expandtab = false,
				shiftwidth = 2,
			},
		}

		local by_ft = {}
		for _, value in ipairs(defaults) do
			if type(value.ft) == "string" then
				by_ft[value.ft] = {
					expandtab = value.expandtab,
					shiftwidth = value.shiftwidth,
				}
			elseif type(value.ft) == "table" then
				for _, ft in ipairs(value.ft) do
					by_ft[ft] = {
						expandtab = value.expandtab,
						shiftwidth = value.shiftwidth,
					}
				end
			end
		end

		local indent = require("guess-indent")
		local config = require("guess-indent.config")
		local utils = require("guess-indent.utils")

		---@param bufnr integer
		---@param name string
		---@param value any
		local function set_buffer_opt(bufnr, name, value)
			if value ~= nil then
				local current = vim.bo[bufnr][name]
				if value ~= current then
					vim.bo[bufnr][name] = value
				end
			end
		end

		---@param bufnr integer?
		---@param context boolean?
		---@param silent boolean?
		function indent.set_from_buffer(bufnr, context, silent) ---@diagnostic disable-line: duplicate-set-field
			bufnr = bufnr or vim.api.nvim_get_current_buf()

			local filetype = vim.bo[bufnr].filetype
			local buftype = vim.bo[bufnr].buftype

			if context then
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end
				-- editorconfig interoperability
				if not config.override_editorconfig then
					local editorconfig = vim.b[bufnr].editorconfig
					if editorconfig and (editorconfig.indent_style or editorconfig.indent_size or editorconfig.tab_width) then
						utils.v_print(1, "Excluded because of editorconfig settings.")
						return
					end
				end

				-- Filter
				utils.v_print(1, "File type:", filetype)
				utils.v_print(1, "Buffer type:", buftype)

				if vim.tbl_contains(config.filetype_exclude, filetype) then
					utils.v_print(1, "Excluded because of filetype.")
					return
				end

				if vim.tbl_contains(config.buftype_exclude, buftype) then
					utils.v_print(1, "Excluded because of buftype.")
					return
				end
			end

			local indentation = indent.guess_from_buffer(bufnr)

			local notification = "Failed to detect indentation style."
			if indentation == "tabs" then
				for opt, value in pairs(config.on_tab_options) do
					set_buffer_opt(bufnr, opt, value)
				end
				notification = "Did set indentation to tabs."
			elseif type(indentation) == "number" and indentation > 0 then
				for opt, value in pairs(config.on_space_options) do
					if value == "detected" then
						value = indentation
					end
					set_buffer_opt(bufnr, opt, value)
				end
				notification = ("Did set indentation to %s space(s)."):format(indentation)
			else
				if by_ft[filetype] ~= nil then
					set_buffer_opt(bufnr, "expandtab", by_ft[filetype].expandtab)
					set_buffer_opt(bufnr, "shiftwidth", by_ft[filetype].shiftwidth)
					set_buffer_opt(bufnr, "tabstop", by_ft[filetype].shiftwidth)
					if vim.bo.expandtab then
						notification = ("Using defaults. Did set indentation to %s space(s)."):format(by_ft[filetype].shiftwidth)
					else
						notification = "Using defaults. Did set indentation to tabs."
					end
				end
			end

			if vim.bo.expandtab then
				vim.opt_local.listchars:append({ lead = " " })
			else
				vim.opt_local.listchars:append({ tab = "  " })
			end

			if not silent then
				vim.notify(notification)
			end
		end

		indent.setup(opts)
	end,
}
