return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local ts = require("nvim-treesitter")

      -- ensure these language parsers are installed (async; only installs missing ones)
      ts.install({
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
      })

      -- On the `main` branch, highlighting and indentation are no longer
      -- toggled via setup(); they are started per-buffer. Enable them for any
      -- buffer whose filetype has a parser available.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            -- enable treesitter-based indentation
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- autotagging (w/ nvim-ts-autotag plugin)
      require("nvim-ts-autotag").setup({})

      -- Treesitter textobjects configuration
      require("nvim-treesitter-textobjects").setup({
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
        },
        move = {
          set_jumps = true, -- whether to set jumps in the jumplist
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local swap = require("nvim-treesitter-textobjects.swap")
      local move = require("nvim-treesitter-textobjects.move")

      -- select (works in visual + operator-pending modes)
      -- You can use the capture groups defined in textobjects.scm
      local select_keymaps = {
        ["a="] = { "@assignment.outer", "Select outer part of an assignment" },
        ["i="] = { "@assignment.inner", "Select inner part of an assignment" },
        ["l="] = { "@assignment.lhs", "Select left hand side of an assignment" },
        ["r="] = { "@assignment.rhs", "Select right hand side of an assignment" },

        -- works for javascript/typescript files (custom capture in after/queries/ecma/textobjects.scm)
        ["a:"] = { "@property.outer", "Select outer part of an object property" },
        ["i:"] = { "@property.inner", "Select inner part of an object property" },
        ["l:"] = { "@property.lhs", "Select left part of an object property" },
        ["r:"] = { "@property.rhs", "Select right part of an object property" },

        ["aa"] = { "@parameter.outer", "Select outer part of a parameter/argument" },
        ["ia"] = { "@parameter.inner", "Select inner part of a parameter/argument" },

        ["ai"] = { "@conditional.outer", "Select outer part of a conditional" },
        ["ii"] = { "@conditional.inner", "Select inner part of a conditional" },

        ["al"] = { "@loop.outer", "Select outer part of a loop" },
        ["il"] = { "@loop.inner", "Select inner part of a loop" },

        ["af"] = { "@call.outer", "Select outer part of a function call" },
        ["if"] = { "@call.inner", "Select inner part of a function call" },

        ["am"] = { "@function.outer", "Select outer part of a method/function definition" },
        ["im"] = { "@function.inner", "Select inner part of a method/function definition" },

        ["ac"] = { "@class.outer", "Select outer part of a class" },
        ["ic"] = { "@class.inner", "Select inner part of a class" },
      }
      for lhs, spec in pairs(select_keymaps) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(spec[1], "textobjects")
        end, { desc = spec[2] })
      end

      -- swap
      vim.keymap.set("n", "<leader>na", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap parameter/argument with next" })
      vim.keymap.set("n", "<leader>n:", function()
        swap.swap_next("@property.outer")
      end, { desc = "Swap object property with next" })
      vim.keymap.set("n", "<leader>nm", function()
        swap.swap_next("@function.outer")
      end, { desc = "Swap function with next" })

      vim.keymap.set("n", "<leader>pa", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap parameter/argument with previous" })
      vim.keymap.set("n", "<leader>p:", function()
        swap.swap_previous("@property.outer")
      end, { desc = "Swap object property with previous" })
      vim.keymap.set("n", "<leader>pm", function()
        swap.swap_previous("@function.outer")
      end, { desc = "Swap function with previous" })

      -- move
      -- Each entry: { query, desc, group } (group defaults to "textobjects")
      local move_keymaps = {
        [move.goto_next_start] = {
          ["]f"] = { "@call.outer", "Next function call start" },
          ["]m"] = { "@function.outer", "Next method/function def start" },
          ["]c"] = { "@class.outer", "Next class start" },
          ["]i"] = { "@conditional.outer", "Next conditional start" },
          ["]l"] = { "@loop.outer", "Next loop start" },
          ["]s"] = { "@scope", "Next scope", "locals" },
          ["]z"] = { "@fold", "Next fold", "folds" },
        },
        [move.goto_next_end] = {
          ["]F"] = { "@call.outer", "Next function call end" },
          ["]M"] = { "@function.outer", "Next method/function def end" },
          ["]C"] = { "@class.outer", "Next class end" },
          ["]I"] = { "@conditional.outer", "Next conditional end" },
          ["]L"] = { "@loop.outer", "Next loop end" },
        },
        [move.goto_previous_start] = {
          ["[f"] = { "@call.outer", "Prev function call start" },
          ["[m"] = { "@function.outer", "Prev method/function def start" },
          ["[c"] = { "@class.outer", "Prev class start" },
          ["[i"] = { "@conditional.outer", "Prev conditional start" },
          ["[l"] = { "@loop.outer", "Prev loop start" },
        },
        [move.goto_previous_end] = {
          ["[F"] = { "@call.outer", "Prev function call end" },
          ["[M"] = { "@function.outer", "Prev method/function def end" },
          ["[C"] = { "@class.outer", "Prev class end" },
          ["[I"] = { "@conditional.outer", "Prev conditional end" },
          ["[L"] = { "@loop.outer", "Prev loop end" },
        },
      }
      for move_fn, keymaps in pairs(move_keymaps) do
        for lhs, spec in pairs(keymaps) do
          vim.keymap.set({ "n", "x", "o" }, lhs, function()
            move_fn(spec[1], spec[3] or "textobjects")
          end, { desc = spec[2] })
        end
      end

      -- NOTE: `incremental_selection` was removed on the treesitter `main`
      -- branch and has no built-in replacement, so it is no longer configured.
    end,
  },
}
