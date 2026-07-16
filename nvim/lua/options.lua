local opt = vim.opt

opt.shortmess:append("I")
opt.number = true
opt.relativenumber = true
opt.laststatus = 2
opt.backspace = "indent,eol,start"
opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Open splits in more natural positions
opt.splitright = true
opt.splitbelow = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Show matching brackets, trailing whitespace, etc.
opt.showmatch = true
opt.list = true
opt.listchars = { tab = "»·", trail = "·", nbsp = "·" }

-- Scroll before hitting the edge
opt.scrolloff = 8

-- Faster screen update (helps gitsigns, etc. feel snappy)
opt.updatetime = 100

-- Keep undo history across sessions (separate dir from vim's,
-- since undo file formats are incompatible)
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/state/nvim/undodir")

-- Keep swap files in one place
opt.directory = vim.fn.expand("~/.local/state/nvim/swapfiles//")

opt.mouse = ""

-- Use a block cursor in all modes (matches vim's terminal default)
opt.guicursor = "a:block"

--- Highlight cursor line
opt.cursorline = true

opt.termguicolors = true

-- Netrw
vim.g.netrw_liststyle = 3 -- Tree-style listing
vim.g.netrw_banner = 0 -- Hide the noisy top banner
vim.g.netrw_altv = 1 -- Vertical split opens to the right
vim.g.netrw_fastbrowse = 2
-- Add line number in netrw
vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"

-- Ensure undo/swap directories exist
for _, dir in ipairs({ "~/.local/state/nvim/undodir", "~/.local/state/nvim/swapfiles" }) do
  local path = vim.fn.expand(dir)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- Send only true yanks (not deletes) to the system clipboard via OSC 52
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" then
      vim.fn.setreg("+", vim.fn.getreg('"'))
    end
  end,
})
