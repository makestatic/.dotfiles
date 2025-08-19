vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.swapfile = false
vim.opt.updatetime = 50
vim.opt.clipboard = "unnamedplus"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.o.background = "dark"

vim.keymap.set("n", "<leader>dv", function()
	vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
end)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system(
		{ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath }
	)
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
	{
		{
			"armannikoyan/rusty",
			-- 'Mofiqul/vscode.nvim',
			-- "briones-gabriel/darcula-solid.nvim",
			-- dependencies = { "rktjmp/lush.nvim" },
			lazy = false,
			priority = 1000,
			opts = {},
			config = function()
				vim.cmd("colorscheme rusty")
			end
		},
		-- For `plugins.lua` users.
		{
			"OXY2DEV/markview.nvim",
			lazy = false,

			-- For `nvim-treesitter` users.
			priority = 49,

			-- For blink.cmp's completion
			-- source
			-- dependencies = {
			--     "saghen/blink.cmp"
			-- },
		},
		{
			'windwp/nvim-autopairs',
			event = "InsertEnter",
			config = true,
			opts = {},
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			---@module "ibl"
			---@type ibl.config
			opts = {
				scope = {
					enabled = true
				}
			},
		},
		{
			"Exafunction/windsurf.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			config = function()
				require("codeium").setup({
					enable_cmp_source = false,
					virtual_text = {
						enabled = true,
						manual = false,
						filetypes = {},
						default_filetype_enabled = true,
						idle_delay = 75,
						virtual_text_priority = 65535,
						map_keys = true,
						accept_fallback = nil,
						key_bindings = {
							accept = "<Tab>",
							accept_word = false,
							accept_line = false,
							clear = false,
							next = "<M-]>",
							prev = "<M-[>",
						}
					}
				})
			end
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			dependencies = { "windwp/nvim-ts-autotag", "axelvc/template-string.nvim" },
			config = function()
				require("nvim-treesitter.configs").setup(
					{
						auto_install = true,
						highlight = { enable = true },
						indent = { enable = true },
						autotag = { enable = true },
						incremental_selection = {
							enable = true,
							keymaps = {
								init_selection = "<enter>",
								node_incremental = "<enter>",
								scope_incremental = false,
								node_decremental = "<bs>"
							}
						}
					}
				)
				require("template-string").setup({})
			end
		},
		{
			"ej-shafran/compile-mode.nvim",
			branch = "latest",
			dependencies = { "nvim-lua/plenary.nvim", { "m00qek/baleia.nvim", tag = "v1.3.0" } },
			config = function()
				vim.g.compile_mode = { baleia_setup = true, bang_expansion = true }
				vim.keymap.set("n", "<leader>cc", ":Compile ")
				vim.keymap.set("n", "<leader>cne", ":NextError<CR>")
			end
		},
		{
			"stevearc/conform.nvim",
			config = function()
				local conform = require("conform")
				conform.setup({ formatters_by_ft = { lua = { "stylua" }, go = { "gofmt", "goimports" }, } })
				vim.keymap.set(
					"n",
					"<leader>fm",
					function()
						conform.format({ lsp_fallback = true, async = true, timeout_ms = 1000 })
					end
				)
			end
		},
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			dependencies = {
				"mason-org/mason.nvim",
				"neovim/nvim-lspconfig",
			},
			event = { "VeryLazy", "BufReadPre", "BufNewFile" },
			opts = function(_)
				local mr = require("mason-registry")
				vim.g.formatters = {}
				mr.refresh(function()
					for _, tool in ipairs(vim.g.formatters) do
						local p = mr.get_package(tool)
						if not p:is_installed() then
							p:install()
						end
					end
				end)

				return {
					ensure_installed = vim.g.lsps,
					automatic_enable = true,
				}
			end,
		},
		{
			"saghen/blink.cmp",
			dependencies = {
				"rafamadriz/friendly-snippets",
				"onsails/lspkind.nvim",
			},
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				fuzzy = { implementation = "rust" },
				appearance = {
					use_nvim_cmp_as_default = false,
					nerd_font_variant = "mono",
				},

				completion = {
					accept = { auto_brackets = { enabled = true } },
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 250,
						treesitter_highlighting = true,
					},
					menu = {
						cmdline_position = function()
							if vim.g.ui_cmdline_pos ~= nil then
								local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
								return { pos[1] - 1, pos[2] }
							end
							local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
							return { vim.o.lines - height, 0 }
						end,

						draw = {
							columns = {
								{ "kind_icon", "label", gap = 1 },
								{ "kind" },
							},
							components = {
								kind_icon = {
									text = function(item)
										local kind = require("lspkind").symbol_map[item.kind] or ""
										return kind .. " "
									end,
									highlight = "CmpItemKind",
								},
								label = {
									text = function(item)
										return item.label
									end,
									highlight = "CmpItemAbbr",
								},
								kind = {
									text = function(item)
										return item.kind
									end,
									highlight = "CmpItemKind",
								},
							},
						},
					},
				},

				keymap = {
					["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
					["<CR>"] = { "accept", "fallback" },

					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
					["<C-up>"] = { "scroll_documentation_up", "fallback" },
					["<C-down>"] = { "scroll_documentation_down", "fallback" },
				},

				signature = {
					enabled = true,
				},

				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					providers = {
						lsp = {
							min_keyword_length = 0, -- Number of characters to trigger porvider
							score_offset = 0, -- Boost/penalize the score of the items
						},
						path = {
							min_keyword_length = 0,
						},
						snippets = {
							min_keyword_length = 2,
						},
						buffer = {
							min_keyword_length = 2,
							max_items = 5,
						},
					},
				},
			},
		},

		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("fzf-lua").setup({})
				vim.keymap.set("n", "<leader>ff", require("fzf-lua").files)
				vim.keymap.set("n", "<leader>fg", require("fzf-lua").live_grep)
				vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers)
			end
		},
		{
			"stevearc/oil.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("oil").setup()
				vim.keymap.set("n", "<leader>e", ":Oil --float<CR>")
			end
		},
		{
			"TimUntersberger/neogit",
			dependencies = "nvim-lua/plenary.nvim",
			config = function()
				require("neogit").setup()
				vim.keymap.set("n", "<leader>ll", ":Neogit<CR>")
			end
		}
	}
)

vim.lsp.config.gopls = {
	cmd = { "gopls" },
	settings = {
		gopls = {
			usePlaceholders = true,
			completeUnimported = true,
			semanticTokens = true,
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
}

-- Keymaps
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
vim.keymap.set("n", "<leader>s", ":split<CR>")
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<leader>t", ":tabnew<CR>")
vim.keymap.set("n", "<leader>x", ":tabclose<CR>")
vim.keymap.set("n", "<leader>j", ":tabprevious<CR>")
vim.keymap.set("n", "<leader>k", ":tabnext<CR>")
vim.keymap.set("n", "<C-j>", "<C-w>w")
vim.keymap.set("n", "<leader>i", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- AutoCmds
vim.api.nvim_create_autocmd(
	"TextYankPost",
	{
		callback = function()
			vim.highlight.on_yank()
		end
	}
)

vim.api.nvim_create_autocmd(
	"BufReadPost",
	{
		callback = function()
			vim.api.nvim_exec('silent! normal! g`"zv', false)
		end
	}
)

-- lua/lsp_keymaps.lua
local opts = { noremap = true, silent = true }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufopts = { buffer = ev.buf, noremap = true, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
		vim.keymap.set("n", "<leader>da", vim.diagnostic.open_float, bufopts)
		vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, bufopts)
	end,
})

vim.keymap.set("n", "<leader><leader>", ":source ~/.config/nvim/init.lua<CR>")
