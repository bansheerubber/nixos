return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	init = function()
		-- Disable entire built-in ftplugin mappings to avoid conflicts.
		-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
		vim.g.no_plugin_maps = true

		-- Or, disable per filetype (add as you like)
		-- vim.g.no_python_maps = true
		-- vim.g.no_ruby_maps = true
		-- vim.g.no_rust_maps = true
		-- vim.g.no_go_maps = true
	end,
	config = function()
		-- function stuff
		vim.keymap.set({ "n", "x", "o" }, "]f", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[f", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "]F", function()
			require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[F", function()
			require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
		end)

		vim.keymap.set({ "x", "o" }, "af", function()
			require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
		end)

		vim.keymap.set({ "x", "o" }, "if", function()
			require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
		end)

		-- argument stuff
		vim.keymap.set({ "n", "x", "o" }, "]a", function()
			require "nvim-treesitter-textobjects.move".goto_next_start("@parameter.inner", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[a", function()
			require "nvim-treesitter-textobjects.move".goto_previous_start("@parameter.inner", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "]A", function()
			require "nvim-treesitter-textobjects.move".goto_next_start("@parameter.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[A", function()
			require "nvim-treesitter-textobjects.move".goto_previous_start("@parameter.outer", "textobjects")
		end)

		vim.keymap.set({ "x", "o" }, "aa", function()
			require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects")
		end)

		vim.keymap.set({ "x", "o" }, "ia", function()
			require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects")
		end)

		-- class stuff
		vim.keymap.set({ "n", "x", "o" }, "]c", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[c", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
		end)

		vim.keymap.set({ "x", "o" }, "ac", function()
			require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
		end)

		vim.keymap.set({ "x", "o" }, "ic", function()
			require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
		end)

		-- scope stuff
		vim.keymap.set({ "n", "x", "o" }, "]s", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[s", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@local.scope", "locals")
		end)

		vim.keymap.set({ "x", "o" }, "as", function()
			require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
		end)

		-- loop movements
		vim.keymap.set({ "n", "x", "o" }, "]l", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[l", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
		end)

		-- fold movements
		vim.keymap.set({ "n", "x", "o" }, "]z", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[z", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@fold", "folds")
		end)

		-- conditional movements
		vim.keymap.set({ "n", "x", "o" }, "]e", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[e", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "]E", function()
			require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.inner", "textobjects")
		end)

		vim.keymap.set({ "n", "x", "o" }, "[E", function()
			require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.inner", "textobjects")
		end)
	end,
}
