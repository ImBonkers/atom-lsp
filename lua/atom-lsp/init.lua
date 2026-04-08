local M = {}

-- Resolve the plugin's own install directory
local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")
local default_bin = plugin_dir .. "/bin/atom-lsp"

function M.setup(opts)
  opts = opts or {}

  -- Resolve server binary: explicit cmd > bundled binary > $PATH
  local cmd = opts.cmd
  if not cmd then
    if vim.fn.executable(default_bin) == 1 then
      cmd = { default_bin }
    elseif vim.fn.executable("atom-lsp") == 1 then
      cmd = { "atom-lsp" }
    else
      vim.notify(
        "[atom-lsp] Server binary not found. Run :AtomLspBuild or add atom-lsp to $PATH",
        vim.log.levels.WARN
      )
      return
    end
  end

  -- :AtomLspBuild command
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

  -- Register with lspconfig
  local ok, configs = pcall(require, "lspconfig.configs")
  if not ok then
    vim.notify("[atom-lsp] nvim-lspconfig not found, falling back to vim.lsp.start", vim.log.levels.WARN)
    -- Fallback: raw vim.lsp.start
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "atom",
      callback = function(ev)
        local root = vim.fs.root(ev.buf, { ".git", "Makefile" }) or vim.fn.getcwd()
        vim.lsp.start({
          name = "atom-lsp",
          cmd = cmd,
          root_dir = root,
        })
      end,
    })
    return
  end

  if not configs.atom_lsp then
    configs.atom_lsp = {
      default_config = {
        cmd = cmd,
        filetypes = { "atom" },
        root_dir = require("lspconfig.util").root_pattern(".git", "Makefile"),
        settings = {},
      },
    }
  end

  require("lspconfig").atom_lsp.setup(opts.lspconfig or {})
end

return M
