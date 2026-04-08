# atom-lsp

Neovim plugin for the [Atom](https://github.com/ImBonkers/Atom) programming language. Provides syntax highlighting, filetype detection, and a built-in LSP server.

## Features

- Syntax highlighting for `.atm` files
- LSP: diagnostics, go-to-definition, hover, completions, references, rename, formatting, inlay hints
- Auto-builds the LSP server from source on install — no manual setup

## Requirements

- Neovim >= 0.10
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

That's it. Lazy clones the repo (with submodules), runs `make` to compile the server, and the plugin auto-detects the binary.

## Configuration

```lua
require("atom-lsp").setup({
  -- Override the server binary (default: auto-detected from plugin dir)
  -- cmd = { "/custom/path/to/atom-lsp" },

  -- Filetypes to attach to (default: { "atom" })
  filetypes = { "atom" },

  -- Files that mark the project root (default: { ".git", "Makefile" })
  root_markers = { ".git", "Makefile" },
})
```

## Commands

| Command | Description |
|---|---|
| `:AtomLspBuild` | Rebuild the LSP server from source (after updating the plugin) |

## LSP Capabilities

| Feature | Keybind | LSP Method |
|---|---|---|
| Diagnostics | automatic | `textDocument/publishDiagnostics` |
| Go to definition | `gd` | `textDocument/definition` |
| Hover | `K` | `textDocument/hover` |
| References | `gr` | `textDocument/references` |
| Rename | `grn` | `textDocument/rename` |
| Completions | `<C-Space>` | `textDocument/completion` |
| Format | `gq` | `textDocument/formatting` |
| Inlay hints | automatic | `textDocument/inlayHint` |

Keybinds are Neovim's built-in LSP defaults (0.10+). No extra mappings needed.

## Updating

When you update the plugin (`:Lazy update atom-lsp`), the `build = "make"` step recompiles the server automatically. You can also run `:AtomLspBuild` manually at any time.
