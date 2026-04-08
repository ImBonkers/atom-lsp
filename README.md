# atom-lsp

Neovim plugin for the [Atom](https://github.com/ImBonkers/Atom) programming language. Provides syntax highlighting, filetype detection, and a built-in LSP server.

## Features

- Syntax highlighting for `.atm` files
- LSP: diagnostics, go-to-definition, hover, completions, references, rename, formatting, inlay hints
- Uses `vim.lsp.config` / `vim.lsp.enable` (Neovim 0.11+)
- Auto-builds the server from source on install

## Requirements

- Neovim >= 0.11
- A C compiler (`cc`, `gcc`, or `clang`)

## Install with Lazy.nvim

```lua
{
  "ImBonkers/atom-lsp",
  ft = "atom",
  build = "make",
  config = function()
    require("atom-lsp").setup()
  end,
}
```

## Configuration

```lua
require("atom-lsp").setup({
  -- Override the server binary (default: auto-detected from plugin dir)
  -- cmd = { "/custom/path/to/atom-lsp" },

  -- Pass options to vim.lsp.config (same shape as your other servers)
  -- config = {
  --   root_markers = { ".git", "Makefile" },
  -- },
})
```

## Commands

| Command | Description |
|---|---|
| `:AtomLspBuild` | Rebuild the LSP server from source |

## LSP Capabilities

| Feature | LSP Method |
|---|---|
| Diagnostics | `textDocument/publishDiagnostics` |
| Go to definition | `textDocument/definition` |
| Hover | `textDocument/hover` |
| References | `textDocument/references` |
| Rename | `textDocument/rename` |
| Completions | `textDocument/completion` |
| Format | `textDocument/formatting` |
| Inlay hints | `textDocument/inlayHint` |

Your existing `LspAttach` keybindings apply automatically.
