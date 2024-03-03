return {
  misc = {
    indents = {
      left = '▏',
      center = '│',
    },
  },
  dap = {
    Stopped = { ' ', 'DiagnosticWarn', 'DapStoppedLine' },
    Breakpoint = ' ',
    BreakpointCondition = ' ',
    BreakpointRejected = { ' ', 'DiagnosticError' },
    LogPoint = '.>',
  },
  diagnostics = {
    error = ' ',
    warn = ' ',
    hint = ' ',
    info = ' ',
  },
  git = {
    simple = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '│' },
      topdelete = { text = '│' },
      changedelete = { text = '│' },
      untracked = { text = '╎' },
    },
    kickstart = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
}
