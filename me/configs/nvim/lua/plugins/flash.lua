return {
	"folke/flash.nvim",
	config = function()
		local flash = require("flash")

		local flash_mode = ""

		vim.keymap.set("n", "s", function()
			local gi = vim.go.ignorecase
			local gs = vim.go.smartcase

			vim.go.ignorecase = true
			vim.go.smartcase = false

			flash_mode = "normal"
			flash.jump()

			vim.go.ignorecase = gi
			vim.go.smartcase = gs
		end, { desc = "Flash" })

		vim.keymap.set("n", "S", function()
			flash_mode = "treesitter"
			flash.treesitter()
		end, { desc = "Flash treesitter" })

		vim.keymap.set("n", "r", function()
			local gi = vim.go.ignorecase
			local gs = vim.go.smartcase

			vim.go.ignorecase = true
			vim.go.smartcase = false

			flash_mode = "normal"
			flash.remote()

			vim.go.ignorecase = gi
			vim.go.smartcase = gs
		end, { desc = "Remote flash" })

		vim.keymap.set("n", "R", function()
			flash_mode = "treesitter"
			flash.treesitter_search()
		end, { desc = "Treesitter search" })

		vim.keymap.set("n", "<c-s>", function()
			flash.toggle()
		end, { desc = "Toggle flash search" })

		rainbow = {
			"FlashTreesitterLabel1",
			"FlashTreesitterLabel2",
			"FlashTreesitterLabel3",
			"FlashTreesitterLabel4",
			"FlashTreesitterLabel5",
			"FlashTreesitterLabel6",
			"FlashTreesitterLabel7",
			"FlashTreesitterLabel8",
		}

		flash.setup({
			label = {
				format = function(opts)
					if flash_mode == "treesitter" then
						local color_index = (opts.match.label:lower():byte() - 97) % #rainbow + 1

						return {
							{
								" " .. opts.match.label .. " ",
								rainbow[color_index],
							},
						}
					end

					return {
						{
							" " .. opts.match.label .. " ",
							opts.hl_group,
						},
					}
				end,
			},
		})
	end,
}
