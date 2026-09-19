# markdown-toc.nvim

A lightweight, high-performance, and zero-dependency  Neovim plugin written in Lua that parses the active markdown buffer and creates an interactive Table of Contents menu utilizing Neovim's native core `vim.ui.select` engine.

## 🚀 Features

- **Universal Picker Compatibility**: Integrates automatically with Telescope, FZF, or vanilla Neovim text pickers seamlessly.
- **Optional Telescope And FZF
## 📦 Installation

```lua

vim.pack.add({
    "https://github.com/janecodelife/markdown-toc.nvim",
})

-- Setup and configure the plugin
require("markdown-toc").setup({
    min_level = 1, -- Include everything from level 1 (#)
    max_level = 6, -- Down to level 6 (######)
})

vim.keymap.set("n", "<leader>mo", "<cmd>MarkdownTOC<cr>", { desc = "Markdown Open TOC" })

```
## ⚙️ Configuration


| Option | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `min_level` | `number` | `1` | The minimum markdown heading depth to parse into the table of contents list. |
| `max_level` | `number` | `6` | The maximum markdown heading depth to parse into the table of contents list. |


# Thank You
