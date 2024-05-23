return { -- Autocompletion
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{
			"saadparwaiz1/cmp_luasnip", -- LuaSnip completion source for nvim-cmp
			dependencies = {
				"L3MON4D3/LuaSnip", -- Snippet engine
				{
					"rafamadriz/friendly-snippets", -- Premade snippets
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			build = (function()
				-- Build Step is needed for regex support in snippets
				-- This is not supported in many windows environments
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
		},

		"onsails/lspkind-nvim", -- Pretty symbols

		-- Adds other completion capabilities
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",

		{ -- Add Codeium as an AI assistant
			"Exafunction/codeium.nvim",
			cond = false,
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			opts = {
				enable_chat = true,
			},
		},
	},
	init = function()
		require("plugin.confs.lspconfig").add_capabilities(require("cmp_nvim_lsp").default_capabilities)
	end,
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		luasnip.config.setup({})

		cmp.setup({
			---@diagnostic disable-next-line:missing-fields
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol_text",
				}),
			},

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			completion = { completeopt = "menu,menuone,noinsert" },

			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<C-n>"] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Accept the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-e>"] = cmp.mapping.confirm({ select = true }),

				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don"t need this, because nvim-cmp will display
				--  completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete({}),

				-- Go forward on each of the expansion locations
				["<C-f>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				-- Go backward on each of the expansion locations
				["<C-b>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "codeium" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
		})

		cmp.setup.filetype({ "sql" }, {
			sources = cmp.config.sources({ { name = "vim-dadbod-completion" } }, { { name = "buffer" } }),
		})

		local cmdmap = cmp.mapping.preset.cmdline()
		cmdmap["<C-E>"] = cmdmap["<C-Y>"] -- don't know how to get this mapping

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmdmap,
			sources = cmp.config.sources({ { name = "buffer" } }),
		})

		cmp.setup.cmdline(":", {
			mapping = cmdmap,
			sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
			---@diagnostic disable-next-line:missing-fields
			matching = { disallow_symbol_nonprefix_matching = false },
		})
	end,
}
