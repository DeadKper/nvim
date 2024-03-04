return { -- install without yarn or npm
  'iamcco/markdown-preview.nvim',
  event = 'VimEnter',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'markdown' },
  build = function()
    vim.fn['mkdp#util#install']()
  end,
}
