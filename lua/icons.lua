return {
  indents = {
    left = '▏',
    center = '│',
    dotted = '┆',
    dotted2 = '╎',
  },
  dap = { --
    Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  },
  diagnostics = {
    Error = ' ',
    Warn = ' ',
    Hint = ' ',
    Info = ' ',
  },
  lualine = {
    error = ' ',
    warn = ' ',
    hint = ' ',
    info = ' ',
  },
  git = {
    add = ' │',
    change = ' │',
    delete = ' _',
    topdelete = ' ‾',
    changedelete = ' ~',
    untracked = ' ┆',
  },
}
