return {
  'rmagatti/auto-session',
  event = 'BufReadPre',
  opts = {
    auto_restore_enabled = false,
    auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
  },
}
