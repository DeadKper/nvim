return { -- Theme inspired by Atom
	"navarasu/onedark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("onedark").setup({
			transparent = true,
			diagnostics = {
				background = false,
			},
			lualine = {
				transparent = true,
			},
		})

		vim.cmd("colorscheme onedark")

		local function set_transparent_hl(hlgroups, fg)
			for _, value in ipairs(hlgroups) do
				local id = vim.fn.hlID(value)
				vim.api.nvim_set_hl(0, value, {
					fg = fg or vim.fn.synIDattr(id, "fg#"),
					sp = vim.fn.synIDattr(id, "sp#"),
					bg = "NONE",
					ctermfg = vim.fn.synIDattr(id, "ctermfg#"),
					ctermbg = vim.fn.synIDattr(id, "ctermbg#"),
				})
			end
		end

		set_transparent_hl({
			"FloatBorder",
			"NormalFloat",
			"Pmenu",
			"Conceal",
		})
		set_transparent_hl({
			"MasonMutedBlock",
		}, "#A0A0A0")

		-- Remove background from lazy
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("background-remove", { clear = true }),
			pattern = { "lazy" },
			once = true,
			callback = function()
				set_transparent_hl({
					"LazyButton",
				})
			end,
		})
	end,
}
