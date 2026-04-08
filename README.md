# atom-lsp

Neovim plugin for the [Atom](https://github.com/ImBonkers/Atom) programming language. Provides syntax highlighting, filetype detection, and LSP support.

## Features

- Syntax highlighting for `.atm` files
- LSP integration: diagnostics, go-to-definition, hover, completions, references, rename, formatting, inlay hints
- Comment string and indent settings

## Requirements

- Neovim >= 0.10
- `atom-lsp` binary on your `$PATH` (or specify the full path)

Build it from the Atom repo:

```bash
cd /path/to/Atom
make lsp
cp build/atom-lsp ~/.local/bin/  # or anywhere on $PATH
```

## Install with Lazy.nvim

```lua
{
  "ImBonkers/atom-lsp",
  ft = "atom",
  opts = {
    -- cmd = { "/full/path/to/atom-lsp" },  -- if not on $PATH
  },
  config = function(_, opts)
    require("atom-lsp").setup(opts)
  end,
}
```

## Manual setup (without plugin manager)

```lua
-- in init.lua
require("atom-lsp").setup({
  cmd = { "/path/to/build/atom-lsp" },
})
```

## Configuration

```lua
require("atom-lsp").setup({
  -- Path to the LSP server binary (default: assumes on $PATH)
  cmd = { "atom-lsp" },

  -- Filetypes to attach to (default: { "atom" })
  filetypes = { "atom" },

  -- Files that mark the project root (default: { ".git", "Makefile" })
  root_markers = { ".git", "Makefile" },
})
```

## LSP Capabilities

| Feature | Keybind (suggested) | LSP Method |
|---|---|---|
| Diagnostics | automatic | `textDocument/publishDiagnostics` |
| Go to definition | `gd` | `textDocument/definition` |
| Hover | `K` | `textDocument/hover` |
| References | `gr` | `textDocument/references` |
| Rename | `<leader>rn` | `textDocument/rename` |
| Completions | `<C-Space>` | `textDocument/completion` |
| Format | `<leader>f` | `textDocument/formatting` |
| Inlay hints | automatic | `textDocument/inlayHint` |

These keybinds are Neovim's LSP defaults (0.10+). No extra mapping needed.
