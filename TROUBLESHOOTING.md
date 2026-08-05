# Troubleshooting Guide

## Plugins Not Loading

### Reload a Specific Plugin

```vim
:Lazy reload <plugin-name>
```

### Check Plugin Status

```vim
:Lazy
```

This opens the lazy.nvim UI showing all plugins, their status, and any errors.

### Clear and Reinstall Plugins

```vim
:Lazy clean
:Lazy install
```

## LSP Issues

### Check LSP Attachment

```vim
:LspInfo
```

Shows which LSP servers are attached to the current buffer and their status.

### Verify LSP Server Installation

```vim
:Mason
```

Opens Mason UI to check installed LSP servers and tools.

### LSP Health Check

```vim
:checkhealth lsp
```

Runs diagnostics on LSP configuration and identifies issues.

### Restart LSP Server

```vim
:LspRestart
```

### View LSP Logs

```vim
:LspLog
```

## Formatting Issues

### Check Formatter Status

```vim
:ConformInfo
```

Shows available formatters for the current buffer and their status.

### Manual Format

```vim
:lua vim.lsp.buf.format()
```

Or use the keymap: `<leader>mp` (format current buffer)

## Treesitter Issues

> nvim-treesitter is on the `main` branch. It requires the `tree-sitter` CLI to
> compile parsers (see SETUP.md → Prerequisites).

### Check Treesitter Status

```vim
:checkhealth nvim-treesitter
```

List installed parsers:

```vim
:lua =require("nvim-treesitter.config").get_installed()
```

### Syntax Highlighting Missing / Wrong

Usually means the parser failed to compile. Check `:TSLog` for errors like
`Error during "tree-sitter build": ENOENT (cmd): 'tree-sitter'` — that means the
`tree-sitter` CLI is not installed or not on Neovim's `PATH`. Install it
(`npm install -g tree-sitter-cli`), confirm `tree-sitter --version` works in the
shell you launch Neovim from, then re-run `:TSUpdate`.

Highlighting is started per-buffer via a `FileType` autocmd in
`lua/abeluzhenko/plugins/nvim-treesitter.lua`; confirm the parser is installed
and the buffer's `filetype` is set.

### Update Treesitter Parsers

```vim
:TSUpdate
```

### Reinstall Parser

```vim
:TSInstall <language>
```

## Performance Issues

### Check Startup Time

```vim
:Lazy profile
```

Identifies which plugins are slowing down startup.

### Measure Startup Time (Terminal)

```bash
nvim --startuptime startup.log
```

Then review `startup.log` to see what takes time.

## Copilot Issues

### Check Copilot Status

```vim
:Copilot status
```

### Re-authenticate Copilot

```vim
:Copilot auth
```

### Restart Copilot

```vim
:Copilot disable
:Copilot enable
```

## General Diagnostics

### Full Health Check

```vim
:checkhealth
```

Runs comprehensive diagnostics on all components.

### Check Neovim Version

```vim
:version
```

Ensure you're running Neovim 0.11+ (required by nvim-treesitter's `main` branch).

## Common Issues

### "Module not found" Error

1. Check file path matches module name
2. Ensure file returns a value/table
3. Restart Neovim

### Keybindings Not Working

1. Check for conflicts: `:verbose map <key>`
2. Verify leader key is set (should be Space)
3. Check which-key for binding info: `<Space>` (wait for popup)

### Colors Look Wrong

1. Check terminal supports true color
2. Verify colorscheme is installed
3. Try `:colorscheme nightfly` manually

### Auto-completion Not Working

1. Check nvim-cmp is loaded: `:Lazy`
2. Verify LSP is attached: `:LspInfo`
3. Check Copilot status: `:Copilot status`
