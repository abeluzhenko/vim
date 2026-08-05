# Setup Guide

## Prerequisites

- **Neovim 0.11+** — required by nvim-treesitter's `main` branch.
- **`tree-sitter` CLI** — nvim-treesitter's `main` branch compiles parsers from
  grammars on install, so the CLI must be installed and on Neovim's `PATH`:

  ```bash
  npm install -g tree-sitter-cli
  # or: cargo install tree-sitter-cli
  ```

  Verify with `tree-sitter --version`. Note: Homebrew's `tree-sitter` formula
  installs only the library, **not** the CLI binary.

## First Launch

When you launch Neovim for the first time, lazy.nvim will automatically:

1. Clone itself to `~/.local/share/nvim/lazy/lazy.nvim`
2. Install all plugins from `plugins/` and `plugins/lsp/`
3. Mason installs LSP servers and tools

## Post-Install Steps

### Authenticate GitHub Copilot

```vim
:Copilot auth
```

Follow the browser prompts to authenticate your GitHub account.

### Treesitter Parsers

On the `main` branch, parsers are compiled from grammars by the `tree-sitter`
CLI (see Prerequisites) and installed asynchronously in the background on first
launch. Check their status with:

```vim
:checkhealth nvim-treesitter
```

Or list installed parsers:

```vim
:lua =require("nvim-treesitter.config").get_installed()
```

## Verification

After initial setup, verify everything is working:

1. Check LSP servers are installed:
   ```vim
   :Mason
   ```

2. Check plugins are loaded:
   ```vim
   :Lazy
   ```

3. Test completion by opening a file and typing - you should see suggestions

4. Test formatting by editing a file and saving (auto-format on save is enabled)
