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

		local function set_transparent_hl(hlgroups)
			for _, value in ipairs(hlgroups) do
				local id = vim.fn.hlID(value)
				vim.api.nvim_set_hl(0, value, {
					fg = vim.fn.synIDattr(id, "fg#"),
					sp = vim.fn.synIDattr(id, "sp#"),
					bg = "NONE",
					ctermfg = vim.fn.synIDattr(id, "ctermfg#"),
					ctermbg = vim.fn.synIDattr(id, "ctermbg#"),
				})
			end
		end

		set_transparent_hl({
			"Float",
			"FloatBorder",
			"Normal",
			"NormalFloat",
			"Pmenu",
		})

		-- Remove background from lazy
		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = vim.api.nvim_create_augroup("background-remove", { clear = true }),
			pattern = { "lazy" },
			callback = function()
				set_transparent_hl({
					"Lazy",
					"LazyButton",
					"LazyProp",
					"LazyDimmed",
				})
			end,
		})
	end,
}
