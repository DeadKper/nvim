return { -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Build Step is needed for regex support in snippets
        -- This is not supported in many windows environments
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
    },
    "saadparwaiz1/cmp_luasnip", -- LuaSnip completion source for nvim-cmp

    -- Adds other completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",

    { -- Add Codeium as an AI assistant
      "Exafunction/codeium.nvim",
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
		require("plugin.setup.cmp")
  end,
}
