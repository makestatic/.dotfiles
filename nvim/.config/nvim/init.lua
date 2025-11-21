vim.g.mapleader = " "
vim.opt.signcolumn = "auto"
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.swapfile = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.clipboard = ""
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 999
vim.opt.sidescrolloff = 8
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.guicursor = ""

vim.keymap.set("n", "<leader>dv", function()
	vim.diagnostic.config({ virtual_lines = not vim.diagnostic.config().virtual_lines })
end)

local signs = { Error = "E", Warn = "W", Info = "I", Hint = "H" }
for type, icon in pairs(signs) do
	vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "echasnovski/mini.surround",        version = "*", opts = {} },
	{ "mathofprimes/nightvision-nvim" },
	{ "skywind3000/vim-quickui" },
	{ "letorbi/vim-colors-modern-borland" },
	{ "nyoom-engineering/oxocarbon.nvim" },
	{ "makestatic/devel.nvim" },
	{ "CosecSecCot/cosec-twilight.nvim" },
	{ "sainnhe/gruvbox-material" },
	{ 'nvim-mini/mini.indentscope',       version = '*', opts = {} },
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
		},
	},
	{ "Mofiqul/dracula.nvim" },
	{ "yorickpeterse/nvim-grey" },
	{ "rebelot/kanagawa.nvim" },
	{ "makestatic/oblique.nvim", },
	{ "phha/zenburn.nvim" },
	{ "Mofiqul/vscode.nvim" },
	{ "armannikoyan/rusty" },
	{ "rktjmp/lush.nvim" },
	{ "vague2k/vague.nvim",      opts = { italic = false } },

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "echasnovski/mini.icons" },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = "",
					section_separators = "",
				},

				sections = {
					lualine_a = { "mode" },
					lualine_c = { "filename" },
					lualine_x = {
						function()
							return vim.o.fileencoding .. " :: " .. vim.bo.filetype
						end,
					},
					lualine_y = { "lsp", "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	{
		"jake-stewart/multicursor.nvim",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()
			local set = vim.keymap.set
			set({ "n", "x" }, "<C-S-Up>", function()
				mc.lineAddCursor(-1)
			end)
			set({ "n", "x" }, "<C-S-Down>", function()
				mc.lineAddCursor(1)
			end)
			set({ "i", "n", "x" }, "<C-l>", '<Esc>:lua require("multicursor-nvim").toggleCursor()<CR><CR>')
			mc.addKeymapLayer(function(layerSet)
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)
				layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { reverse = true })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { reverse = true })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = { "windwp/nvim-ts-autotag", "axelvc/template-string.nvim" },
		config = function()
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = false,
						node_decremental = "<BS>",
					},
				},
			})
			require("template-string").setup({})
		end,
	},

	{
		"ej-shafran/compile-mode.nvim",
		branch = "latest",
		dependencies = { "nvim-lua/plenary.nvim", { "m00qek/baleia.nvim", tag = "v1.3.0" } },
		config = function()
			vim.g.compile_mode = { baleia_setup = true, bang_expansion = true }
			vim.keymap.set("n", "<leader>cc", ":Compile ")
			vim.keymap.set("n", "<leader>cne", ":NextError<CR>")
		end,
	},

	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt", "goimports" },
				},
			})
			vim.keymap.set("n", "<leader>fm", function()
				conform.format({ lsp_fallback = true, async = true, timeout_ms = 1000 })
			end)
		end,
	},

	{ "mason-org/mason.nvim",  opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
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
			return { ensure_installed = vim.g.lsps, automatic_enable = true }
		end,
	},

	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},
		opts = {
			fuzzy = { implementation = "rust" },
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 0,
					treesitter_highlighting = true,
				},
				menu = {
					cmdline_position = function()
						if vim.g.ui_cmdline_pos ~= nil then
							local pos = vim.g.ui_cmdline_pos
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
				["<C-n>"] = { "show", "select_next", "fallback" },
			},

			signature = {
				enabled = true,
			},

			sources = {
				default = { "cmdline", "lsp", "path", "snippets", "buffer" },
				providers = {
					cmdline = {
						max_items = 10,
					},
					lsp = {
						max_items = 10,
						min_keyword_length = 0,
						score_offset = 0,
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
		'krady21/compiler-explorer.nvim',
		dependencies = {
			'stevearc/dressing.nvim',
		},
		config = function()
			require("compiler-explorer").setup({
				line_match = {
					highlight = true,
					jump = true,
				},
				open_qflist = true,
				split = "vsplit",
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({})
			vim.keymap.set("n", "<leader>ff", require("fzf-lua").files)
			vim.keymap.set("n", "<leader>fq", require("fzf-lua").lsp_document_diagnostics)
			vim.keymap.set("n", "<leader>fg", require("fzf-lua").live_grep)
			vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers)
			vim.keymap.set("n", "<leader>man", require("fzf-lua").manpages)
		end,
	},

	{
		"Vonr/align.nvim",
		branch = "v2",
		lazy = true,
		init = function()
			vim.keymap.set("x", "aa", function()
				require("align").align_to_string({
					preview = true,
					regex = false,
				})
			end, { noremap = true, silent = true })
		end,
	},

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "<leader>e", ":Oil<CR>")
		end,
	},

	{
		"cdmill/focus.nvim",
		cmd = { "Focus", "Zen", "Narrow" },
		opts = {
		}
	},

	{
		"TimUntersberger/neogit",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup()
			vim.keymap.set("n", "<leader>ll", ":Neogit<CR>")
		end,
	},
})

-- LSP
local lsp = vim.lsp

lsp.config("c3_lsp", { cmd = { "c3lsp" }, filetypes = { "c3", "c3i" } })
lsp.enable("c3_lsp")

lsp.config(
	"clangd",
	{ cmd = { "clangd" }, filetypes = { "c", "cpp", "cc" }, root_markers = { "compile_commands.json" } }
)
lsp.enable("clangd")

lsp.config("serve_d", {
	cmd = { "serve-d" },
	filetypes = { "d", "di" },
	root_markers = { "dub.json", "dub.sdl" },
	settings = { d = { dmdPath = "ldc2", enableAutoComplete = true } },
})
lsp.enable("serve_d")

lsp.config("zls", { settings = { zls = { zig_lib_path = "/opt/zig/lib/" } } })
lsp.enable("zls")

-- KEYMAPS
local opts = { noremap = true, silent = true }
vim.keymap.set("v", "<C-y>", '"+y', opts)
vim.keymap.set("n", "<C-y>", '"+yy', opts)
vim.keymap.set("n", "<C-p>", '"+p', opts)
vim.keymap.set("i", "<C-p>", "<C-r>+", opts)

vim.keymap.set("n", "u", ":undo<CR>")
vim.keymap.set("n", "U", ":redo<CR>")
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
vim.keymap.set("n", "<leader>s", ":split<CR>")
vim.keymap.set("n", "<Tab>", ":bnext<CR>")
vim.keymap.set("n", "<leader>t", ":tabnew<CR>")
vim.keymap.set("n", "<leader>x", ":tabclose<CR>")
vim.keymap.set("n", "<leader>j", ":tabnext<CR>")
vim.keymap.set("n", "<C-j>", "<C-w>w")

vim.keymap.set("n", "<leader>i", function()
	lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })

-- Neovide
vim.keymap.set('n', '<C-=>', '<nop>', { noremap = true })
vim.keymap.set('n', '<C-->', '<nop>', { noremap = true })
vim.keymap.set('n', '<C-=>', function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, opts)
vim.keymap.set('n', '<C-->', function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end, opts)

-- AUTOCMDS
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

-- LSP ATTACH KEYMAPS
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local buf = ev.buf
		local lsp = vim.lsp.buf
		local opts = { buffer = buf, noremap = true, silent = true }
		local k = vim.keymap.set

		k("n", "gd", lsp.definition, opts)
		k("n", "gD", lsp.declaration, opts)
		k("n", "gi", lsp.implementation, opts)
		k("n", "gr", lsp.references, opts)
		k("n", "K", lsp.hover, opts)
		k("n", "<leader>K", lsp.signature_help, opts)
		k("n", "<leader>rn", lsp.rename, opts)
		k({ "n", "v" }, "<leader>ca", lsp.code_action, opts)
		k("n", "[d", vim.diagnostic.goto_prev, opts)
		k("n", "]d", vim.diagnostic.goto_next, opts)
		k("n", "<C-k>", vim.diagnostic.open_float, opts)
	end,
})

vim.cmd("colorscheme devel")
-- vim.cmd([[colorscheme gruber-darker]])
-- vim.opt.background = "light"
-- vim.cmd([[colorscheme grey]])
-- vim.cmd([[colorscheme vscode]])
-- vim.cmd("colorscheme oblique")
-- vim.cmd [[
--   hi Cursor guifg=NONE guibg=Black
--   set guicursor=i-r-o-n-v-c:block-Cursor
-- ]]

vim.keymap.set("n", "<leader><leader>", ":source ~/.config/nvim/init.lua<CR>")
