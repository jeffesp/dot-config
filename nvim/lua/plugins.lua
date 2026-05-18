return {

  -- Colorscheme
  {
    "catppuccin/nvim",
    name     = "catppuccin",
    priority = 1000,
    config   = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Space-leader popup — shows available keymaps as you type
  {
    "folke/which-key.nvim",
    event  = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({ delay = 300 })
      wk.add({
        { "<leader>g", group = "git" },
      })
    end,
  },

  -- Fuzzy picker for files, buffers, grep, symbols, diagnostics
  -- Requires fzf on PATH: `brew install fzf`
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({ "telescope" })
      local map = vim.keymap.set
      map("n", "<leader>f",  "<cmd>FzfLua files<CR>",                 { desc = "Find files" })
      map("n", "<leader>b",  "<cmd>FzfLua buffers<CR>",               { desc = "Buffers" })
      map("n", "<leader>/",  "<cmd>FzfLua live_grep<CR>",             { desc = "Live grep" })
      map("n", "<leader>s",  "<cmd>FzfLua lsp_document_symbols<CR>",  { desc = "Document symbols" })
      map("n", "<leader>S",  "<cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "Workspace symbols" })
      map("n", "<leader>d",  "<cmd>FzfLua diagnostics_document<CR>",  { desc = "Document diagnostics" })
      map("n", "<leader>D",  "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "Workspace diagnostics" })
      map("n", "<leader>'",  "<cmd>FzfLua resume<CR>",                { desc = "Resume last picker" })
    end,
  },

  -- Treesitter: syntax highlighting and indentation
  {
    "nvim-treesitter/nvim-treesitter",
    build  = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "typescript", "tsx", "go", "gomod", "gosum",
          "lua", "vim", "vimdoc", "json", "yaml",
          "markdown", "markdown_inline",
        },
      })
    end,
  },

  -- Completion — listed before lspconfig so capabilities are ready
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap     = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- LSP: mason auto-installs servers, vim.lsp.config (nvim 0.11+) wires them up
  -- nvim-lspconfig is kept as a dependency for its server definitions only
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "gopls", "lua_ls" },
      })

      -- Apply blink.cmp capabilities to every server via the '*' glob
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses    = { unusedparams = true },
            staticcheck = true,
            gofumpt     = true,
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
              library         = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.enable({ "ts_ls", "gopls", "lua_ls" })

      -- Helix-like LSP keymaps, active only when a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end

          map("gd",        vim.lsp.buf.definition,      "Go to definition")
          map("gr",        vim.lsp.buf.references,      "References")
          map("gi",        vim.lsp.buf.implementation,  "Go to implementation")
          map("gy",        vim.lsp.buf.type_definition, "Go to type definition")
          map("K",         vim.lsp.buf.hover,            "Hover docs")
          map("<leader>a", vim.lsp.buf.code_action,      "Code action")
          map("<leader>r", vim.lsp.buf.rename,           "Rename symbol")
        end,
      })
    end,
  },

  -- Format on save
  -- For TS/JS you'll want prettierd: `npm i -g @fsouza/prettierd`
  -- For Go, goimports is installed via mason automatically
  {
    "stevearc/conform.nvim",
    event  = "BufWritePre",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript      = { "prettierd", "prettier", stop_after_first = true },
          typescript      = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          go              = { "goimports", "gofmt" },
          lua             = { "stylua" },
        },
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      })
    end,
  },

  -- Git: hunk signs in gutter + stage/reset/blame actions
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("]h",         gs.next_hunk,    "Next hunk")
          map("[h",         gs.prev_hunk,    "Prev hunk")
          map("<leader>gs", gs.stage_hunk,   "Stage hunk")
          map("<leader>gr", gs.reset_hunk,   "Reset hunk")
          map("<leader>gp", gs.preview_hunk, "Preview hunk")
          map("<leader>gb", gs.blame_line,   "Blame line")
        end,
      })
    end,
  },

  { "echasnovski/mini.pairs",      version = "*", config = true },
  { "echasnovski/mini.surround",   version = "*", config = true },
  { "echasnovski/mini.statusline", version = "*", config = true },
}
