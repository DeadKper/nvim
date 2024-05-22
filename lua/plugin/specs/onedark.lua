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
				local id = vim.fn.synIDtrans(vim.fn.hlID(value))
				vim.api.nvim_set_hl(0, value, {
					fg = fg or vim.fn.synIDattr(id, "fg#"),
					bg = "NONE",
					sp = vim.fn.synIDattr(id, "sp#"),
					bold = vim.fn.synIDattr(id, "bold") == "1",
					italic = vim.fn.synIDattr(id, "italic") == "1",
					reverse = vim.fn.synIDattr(id, "reverse") == "1" or vim.fn.synIDattr(id, "inverse") == "1",
					standout = vim.fn.synIDattr(id, "standout") == "1",
					underline = vim.fn.synIDattr(id, "underline") == "1",
					undercurl = vim.fn.synIDattr(id, "undercurl") == "1",
					underdouble = vim.fn.synIDattr(id, "underdouble") == "1",
					underdotted = vim.fn.synIDattr(id, "underdotted") == "1",
					underdashed = vim.fn.synIDattr(id, "underdashed") == "1",
					strikethrough = vim.fn.synIDattr(id, "strikethrough") == "1",
					altfont = vim.fn.synIDattr(id, "altfont") == "1",
					nocombine = vim.fn.synIDattr(id, "nocombine") == "1",
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
