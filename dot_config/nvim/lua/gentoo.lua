return {
  {
    'gentoo/gentoo-syntax',
    ft = { 'ebuild', 'eclass', 'gentoo' }
  },
  {
    'axsk/ebuild-mode',
    ft = { 'ebuild', 'eclass', 'gentoo' }
  },
  {
    'tpope/vim-dispatch',
  },
  {
    'bash-lsp/bash-language-server',
    config = function()
      require'lspconfig'.bashls.setup{}
    end
  },
  {
    'ms-jpq/coq_nvim',
    branch = 'coq',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>ep', ':COQnow<CR>:!emerge --ask <C-r><C-w><CR>', { noremap = true, silent = false })
    end
  },
  {
    'SirVer/ultisnips',
    requires = {'honza/vim-snippets'}
  }
}

