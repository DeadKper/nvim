return { -- Requires a nerd font
  lines = {
    left = '▏',
    center = '│',
    split = { '╎', '┆' },
  },
  dap = {
    Stopped = { '󰏥 ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = '󰍶 ',
    BreakpointRejected = { '󱑙 ', 'DiagnosticError' },
    LogPoint = ' ',
  },
  fold = {
    open = '',
    close = '',
  },
  diagnostics = {
    error = ' ',
    warn = ' ',
    hint = ' ',
    info = ' ',
  },
  comments = {
    fix = ' ',
    todo = ' ',
    hack = ' ',
    warn = ' ',
    perf = '󰓅 ',
    note = ' ',
    test = ' ',
  },
  git = {
    add = '┃',
    change = '┃',
    delete = '▁',
    topdelete = '▔',
    changedelete = '┇',
    untracked = '┇',
  },
}
