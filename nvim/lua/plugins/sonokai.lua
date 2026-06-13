return {
  "sainnhe/sonokai",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.sonokai_style = "shusia"
    vim.g.sonokai_better_performance = 1

    vim.cmd.colorscheme("sonokai")

    -- Background transparent
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
  end,
}
