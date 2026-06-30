return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "pyright", "lua_ls", "bashls", "clangd" },
    })

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    -- Pin pyright to the system interpreter by default. Without this,
    -- pyright's auto-discovery can wander into unrelated sibling
    -- projects' .venv directories when the current project has none.
    -- Use :PyrightSetPython to point at a project's own venv instead.
    vim.lsp.config("pyright", {
      settings = {
        python = { pythonPath = vim.fn.exepath("python3") },
      },
    })

    -- Show diagnostics like VS Code: underline the offending text instead
    -- of cluttering the sign column or showing inline virtual text.
    vim.diagnostic.config({
      virtual_text = false,
      underline = true,
      signs = false,
    })

    -- :PyrightSetPython <path-to-python> sets the interpreter pyright uses
    -- for the current project and restarts the server to pick it up.
    vim.api.nvim_create_user_command("PyrightSetPython", function(args)
      vim.lsp.config("pyright", {
        settings = {
          python = { pythonPath = vim.fn.expand(args.args) },
        },
      })
      vim.cmd("LspRestart pyright")
    end, { nargs = 1, complete = "file" })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })
  end,
}
