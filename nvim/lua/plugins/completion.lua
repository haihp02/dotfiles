return {
  "saghen/blink.cmp",
  version = "1.*",
  opts = {
    keymap = {
      preset = "none",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-y>"] = { "select_and_accept" },
      ["<C-n>"] = { "select_next" },
      ["<C-p>"] = { "select_prev" },
      ["<C-e>"] = { "cancel" },
    },
    completion = {
      menu = { auto_show = false },
      documentation = { auto_show = true },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
  },
}
