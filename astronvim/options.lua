return function(local_vim)
  vim.api.nvim_create_user_command(
    'StartCopy',
    ":set norelativenumber | :set nonumber | :set wrap | :set signcolumn=no | :only | :IBLDisable",
    {bang = true}
  )
  vim.api.nvim_create_user_command(
    'EndCopy',
    "set relativenumber | :set number | :set nowrap | :set signcolumn=yes | :IBLEnable",
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
    tabstop = 2,
    autoread = true,
    softtabstop = 2,
    shiftwidth = 2,
    expandtab = true,
    autoindent = true,
    showcmd = true,
    wildmenu = true,
    wildmode = "longest:full,full",
    laststatus = 2,
    colorcolumn = "101",
    viminfo = "'20,<10000",
  }
  local_vim.g = {
    mapleader = " ", -- sets vim.g.mapleader
    autoformat_enabled = true, -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
    cmp_enabled = false, -- enable completion at start
    autopairs_enabled = true, -- enable autopairs at start
    diagnostics_mode = 3, -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
    icons_enabled = true, -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
    ui_notifications_enabled = true, -- disable notifications when toggling UI elements
    signcolumn = "no",
    copilot_assume_mapped = true, -- GitHub copilot
    max_file = { size = 1024 * 100, lines = 10000 }, -- copied from https://github.com/AstroNvim/AstroNvim/blob/271c9c3f71c2e315cb16c31276dec81ddca6a5a6/lua/astronvim/options.lua#L53
  }
  return local_vim
end
