return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Extra space after file icons — works around terminals that
    -- miscalculate double-width Nerd Font glyphs and clip/half-color them
    file_icon_padding = " ",
    winopts = {
      preview = {
        hidden = true, -- hidden by default, toggle with <F4>
      },
    },
  },
}
