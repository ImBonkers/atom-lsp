local M = {}

M.defaults = {
  cmd = { "atom-lsp" },
  filetypes = { "atom" },
  root_markers = { ".git", "Makefile" },
}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", M.defaults, opts or {})

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "atom",
    callback = function(ev)
      -- Find project root
      local root = vim.fs.root(ev.buf, opts.root_markers) or vim.fn.getcwd()

      vim.lsp.start({
        name = "atom-lsp",
        cmd = opts.cmd,
        root_dir = root,
        capabilities = vim.lsp.protocol.make_client_capabilities(),
      })
    end,
  })
end

return M
