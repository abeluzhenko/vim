# Neovim Configuration

## WHAT: Repository Overview

Personal Neovim configuration that provides a modern IDE experience. Written entirely in Lua following modern Neovim best practices.

### Tech Stack

- **Language**: Lua (Neovim 0.11+, required by nvim-treesitter `main` branch)
- **Plugin Manager**: lazy.nvim
- **LSP Management**: Mason + mason-lspconfig
- **Formatter**: conform.nvim (oxfmt, stylua)
- **Linter**: nvim-lint (eslint_d)
- **Completion**: nvim-cmp + GitHub Copilot
- **Fuzzy Finder**: Telescope
- **Syntax Highlighting**: Treesitter (`main` branch)
- **Version Control**: Gitsigns + Diffview

### External Prerequisites

- **`tree-sitter` CLI** — required by nvim-treesitter's `main` branch, which
  compiles parsers from grammars on install (unlike the old `master` branch).
  Install with `npm install -g tree-sitter-cli` (or `cargo install tree-sitter-cli`).
  It must be on the `PATH` seen by Neovim. Note: Homebrew's `tree-sitter`
  formula ships only the library, not the CLI binary.

### Key Features

- LSP support: TypeScript, Lua, HTML, CSS, C/C++, Arduino
- GitHub Copilot AI-assisted coding
- Auto-formatting on save
- Fuzzy file finding and live grep
- Git integration with visual diffs
- Auto-completion with snippets
- Session management
- Space as leader key

---

## WHY: Structure & Organization

Modular structure separating concerns for easy maintenance.

```
nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin versions
├── .stylua.toml                # Lua formatter config
│
├── lua/abeluzhenko/
│   ├── lazy.lua                # Plugin manager bootstrap
│   │
│   ├── core/                   # Core Neovim configuration
│   │   ├── init.lua            # Loads keymaps and options
│   │   ├── keymaps.lua         # Custom key mappings
│   │   └── options.lua         # Editor settings
│   │
│   └── plugins/                # Plugin configs (one per file)
│       ├── init.lua            # Basic utilities
│       ├── [28+ plugins].lua   # Individual configs
│       │
│       └── lsp/                # Language Server configs
│           ├── mason.lua       # LSP installer
│           ├── lspconfig.lua   # LSP configurations
│           ├── none-ls.lua     # Non-LSP sources
│           └── mason-workaround.lua
│
└── after/
    └── queries/ecma/
        └── textobjects.scm     # Custom Treesitter text objects
```

### Directory Details

#### `init.lua` (Root)

Entry point loading:

1. Core settings (`abeluzhenko.core`)
2. Plugin manager (`abeluzhenko.lazy`)

#### `lua/abeluzhenko/core/`

Fundamental configurations independent of plugins:

**`options.lua`** (lua/abeluzhenko/core/options.lua):

- Line numbers: relative + absolute
- Indentation: 2 spaces, expand tabs
- Search: smart case
- UI: cursor line, colors, clipboard integration
- Splits: right/below, no swapfile

**`keymaps.lua`** (lua/abeluzhenko/core/keymaps.lua):

- Leader: `<Space>`
- Insert mode escape: `jk`
- Window management: `<leader>s[v|h|e|x]`
- Tab management: `<leader>t[o|x|n|p|f]`
- Abbreviations: `dvo` (DiffviewOpen), `dvh` (DiffviewFileHistory), `gs` (Gitsigns)

#### `lua/abeluzhenko/plugins/`

28+ plugin configuration files organized by purpose:

**UI & Navigation**: nvim-tree, telescope, bufferline, lualine, alpha-nvim, which-key, incline-nvim

**Editing**: nvim-cmp, copilot.lua, nvim-autopairs, nvim-surround, comment.lua, inc-rename-nvim

**Code Intelligence**: nvim-treesitter (`main` branch), nvim-treesitter-text-objects, treesitter-context, lsp-signature

> **nvim-treesitter is on the `main` branch**, which has a different API from
> the legacy `master` branch:
>
> - Parsers are installed via `require("nvim-treesitter").install({...})`
>   (async, compiles via the `tree-sitter` CLI) — not `ensure_installed`.
> - `setup()` only accepts `install_dir`; `highlight`/`indent`/`textobjects`/
>   `incremental_selection` keys are ignored.
> - Highlighting and indentation are started per-buffer in a `FileType`
>   autocmd (`vim.treesitter.start()` + treesitter `indentexpr`).
> - Textobjects use manual keymaps via the `nvim-treesitter-textobjects`
>   `select`/`swap`/`move` modules.
> - `incremental_selection` was removed with no built-in replacement.
>
> See `lua/abeluzhenko/plugins/nvim-treesitter.lua`.

**Formatting & Linting**: formatting.lua (conform.nvim), linting.lua (nvim-lint)

**Git**: gitsigns.lua, diffview.lua

**Visual**: colorscheme.lua (nightfly), colorizer.lua, dressing.lua, nvim-web-devicons

**Workflow**: auto-session.lua, outline.lua, vim-maximizer

Each plugin file returns a lazy.nvim spec with repository, dependencies, config, and keymaps.

#### `lua/abeluzhenko/plugins/lsp/`

**`mason.lua`** (lua/abeluzhenko/plugins/lsp/mason.lua):

- Auto-installs LSP servers: ts_ls, html, cssls, lua_ls, emmet_ls, arduino_language_server, clangd
- Auto-installs tools: oxfmt, stylua, eslint_d

**`lspconfig.lua`**: Configures LSP servers with keybindings (go to definition, references, etc.)

#### `lua/abeluzhenko/lazy.lua`

Plugin manager bootstrap:

1. Auto-installs lazy.nvim if missing
2. Imports plugins from `abeluzhenko.plugins` and `abeluzhenko.plugins.lsp`
3. Enables update checking
4. Initializes Copilot

#### `after/queries/ecma/`

Custom Treesitter text objects for JavaScript/TypeScript:

- `@property.lhs` - Property key
- `@property.rhs` - Property value
- `@property.inner` - Value only
- `@property.outer` - Full property

### Configuration Philosophy

**Modular**: One file per plugin for easy enable/disable

**Lazy Loading**: Plugins load on-demand for fast startup

**Convention**: Follows Lua module conventions for auto-import

**Separation**: core/ (editor), plugins/ (features), plugins/lsp/ (language support), after/ (overrides)

---

## HOW: Working with This Configuration

### File Locations

- **Plugins**: `~/.local/share/nvim/lazy/`
- **LSP servers**: `~/.local/share/nvim/mason/`
- **Sessions**: `~/.local/share/nvim/sessions/`

### Task-Specific Guides

For detailed instructions on specific tasks, refer to these guides:

- **[SETUP.md](SETUP.md)** - First-time installation and post-install verification steps
- **[CUSTOMIZATION.md](CUSTOMIZATION.md)** - How to add plugins, modify keybindings, add LSP languages, change formatters
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Debug commands and solutions for common issues
