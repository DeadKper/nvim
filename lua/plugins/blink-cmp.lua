return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			config = function()
				require("luasnip").setup({})
				require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/lua/luasnip" } })
			end,
		},
		"folke/lazydev.nvim",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",
			["<C-e>"] = { "select_and_accept", "snippet_forward", "fallback" },
			["<C-f>"] = { "snippet_forward", "fallback" },
			["<C-b>"] = { "snippet_backward", "fallback" },
			["<Tab>"] = {},
			["<S-Tab>"] = {},
		},

		cmdline = {
			keymap = { preset = "inherit" },
			completion = { menu = { auto_show = true } },
		},

		appearance = {
			nerd_font_variant = "normal",
		},

		completion = {
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},

		snippets = { preset = "luasnip" },

		fuzzy = { implementation = "prefer_rust" },

		signature = { enabled = true },
	},
}
