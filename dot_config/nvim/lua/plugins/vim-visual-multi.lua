return {
  -- Outros plugins...
  {
    'mg979/vim-visual-multi',
    branch = 'master',
    config = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
      }
    end,
  },
  -- Outros plugins...
}

