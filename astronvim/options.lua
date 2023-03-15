return function(local_vim)
  vim.api.nvim_create_user_command(
    'StartCopy',
    ":set norelativenumber | :set nonumber | :set wrap | :set signcolumn=no | :only | :IndentBlanklineDisable",
    {bang = true}
  )
  vim.api.nvim_create_user_command(
    'EndCopy',
    "set relativenumber | :set number | :set nowrap | :IndentBlanklineEnable",
    {bang = true}
  )


  local_vim.opt = {
    -- set to true or false etc.
    mouse = '',
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    spell = false, -- sets vim.opt.spell
    signcolumn = "auto", -- sets vim.opt.signcolumn to auto
    wrap = false, -- sets vim.opt.wrap
    tabstop = 4,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    autoindent = true,
    showcmd = true,
    wildmenu = true,
    wildmode = "longest:full,full",
    laststatus = 2,
    colorcolumn = "101",
  }
  local_vim.g = {
    mapleader = " ", -- sets vim.g.mapleader
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = true, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    signcolumn = "no",
  }
  return local_vim
end
