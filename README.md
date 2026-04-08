# atom-lsp

Neovim plugin for the [Atom](https://github.com/ImBonkers/Atom) programming language. Provides syntax highlighting, filetype detection, and a built-in LSP server that integrates with [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

## Features

- Syntax highlighting for `.atm` files
- LSP: diagnostics, go-to-definition, hover, completions, references, rename, formatting, inlay hints
- Registers `atom_lsp` with nvim-lspconfig (`:LspInfo`, `:LspRestart`, etc.)
- Auto-builds the server from source on install

## Requirements

- Neovim >= 0.10
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) (recommended, falls back to `vim.lsp.start` without it)
- A C compiler (`cc`, `gcc`, or `clang`)

## Install with Lazy.nvim

```lua
{
  "ImBonkers/atom-lsp",
  ft = "atom",
  build = "make",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    require("atom-lsp").setup()
  end,
}
```

Lazy clones the repo with submodules, `make` compiles the server, and opening any `.atm` file starts the LSP automatically.

## Configuration

```lua
require("atom-lsp").setup({
  -- Override the server binary (default: auto-detected from plugin dir)
  -- cmd = { "/custom/path/to/atom-lsp" },

  -- Pass options directly to lspconfig's setup()
  -- lspconfig = {
  --   on_attach = function(client, bufnr) ... end,
  --   capabilities = require("cmp_nvim_lsp").default_capabilities(),
  -- },
})
```

## Commands

| Command | Description |
|---|---|
| `:AtomLspBuild` | Rebuild the LSP server from source |
| `:LspInfo` | Show attached LSP clients (from lspconfig) |
| `:LspRestart` | Restart the atom-lsp server |

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

`:Lazy update atom-lsp` pulls new source and re-runs `make` automatically.
