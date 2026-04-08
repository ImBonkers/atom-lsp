local M = {}

-- Resolve the plugin's own install directory
local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
local default_bin = plugin_dir .. "/bin/atom-lsp"

M.defaults = {
  cmd = nil, -- auto-detected from plugin dir
  filetypes = { "atom" },
  root_markers = { ".git", "Makefile" },
}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", M.defaults, opts or {})

  -- Use bundled binary if no explicit cmd and the binary exists
  if not opts.cmd then
    if vim.fn.executable(default_bin) == 1 then
      opts.cmd = { default_bin }
    elseif vim.fn.executable("atom-lsp") == 1 then
      opts.cmd = { "atom-lsp" }
    else
      vim.notify(
        "[atom-lsp] Server binary not found. Run :AtomLspBuild or add atom-lsp to $PATH",
        vim.log.levels.WARN
      )
      return
    end
  end

  -- :AtomLspBuild command to compile the server
  vim.api.nvim_create_user_command("AtomLspBuild", function()
    vim.notify("[atom-lsp] Building server...", vim.log.levels.INFO)
    vim.fn.jobstart({ "make", "-C", plugin_dir }, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("[atom-lsp] Build successful", vim.log.levels.INFO)
        else
          vim.notify("[atom-lsp] Build failed (exit " .. code .. ")", vim.log.levels.ERROR)
        end
      end,
    })
  end, { desc = "Build the atom-lsp server from source" })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = opts.filetypes,
    callback = function(ev)
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
