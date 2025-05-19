return {
	-- "nmac427/guess-indent.nvim",
	"DeadKper/guess-indent.nvim",
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

		---@param indentation integer|"tabs"?
		---@param bufnr integer?
		---@param silent boolean?
		function indent.set_indentation(indentation, bufnr, silent) ---@diagnostic disable-line: duplicate-set-field
			bufnr = bufnr or vim.api.nvim_get_current_buf()
			local filetype = vim.bo[bufnr].filetype

			local detected = true
			local notification = "Failed to detect indentation style."
			if indentation == "tabs" then
				for opt, value in pairs(config.on_tab_options) do
					set_buffer_opt(bufnr, opt, value)
				end
				if by_ft[filetype] ~= nil then
					set_buffer_opt(bufnr, "tabstop", by_ft[filetype].shiftwidth)
					set_buffer_opt(bufnr, "shiftwidth", by_ft[filetype].shiftwidth)
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
				else
					detected = false
				end
			end

			if detected then
				if vim.bo.expandtab then
					vim.opt_local.listchars:append({ tab = require("core.icons").listchars.tab, lead = " " })
				else
					vim.opt_local.listchars:append({ lead = require("core.icons").listchars.lead, tab = "  " })
				end
			end

			if not silent then
				vim.notify(notification)
			end
		end

		indent.setup(opts)
	end,
}
