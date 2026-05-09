# Neovim Config — Shortcuts Reference

`<leader>` is Space. Plugin manager: lazy.nvim. Theme: Catppuccin.

---

## Navigation

| Key | Action |
|-----|--------|
| `<C-h>` | Move focus to left window |
| `<C-l>` | Move focus to right window |
| `<C-j>` | Move focus to lower window |
| `<C-k>` | Move focus to upper window |
| `<C-Left/Right/Up/Down>` | Same as above (arrow variant) |
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `<leader>x` | Close current buffer |
| `t` | Toggle file tree (NvimTree) |

---

## Search (Telescope)

| Key | Action |
|-----|--------|
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep (from cwd) |
| `<D-F>` / `<C-S-f>` | Global search (live grep) |
| `<leader>sw` | Search word under cursor |
| `<leader>s.` | Recent files |
| `<leader>sr` | Resume last search |
| `<leader>sd` | Search diagnostics |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>ss` | Select Telescope picker |
| `<leader>s/` | Live grep in open buffers |
| `<leader>sn` | Find files in Neovim config |
| `<leader><leader>` | Switch between open buffers |
| `<leader>/` | Fuzzy search in current buffer |

---

## LSP (active when a language server is attached)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gvd` | Go to definition in vertical split |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `K` | Hover documentation |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols |
| `<leader>ws` | Workspace symbols |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |

---

## Completion (insert mode)

| Key | Action |
|-----|--------|
| `<C-n>` | Next completion item |
| `<C-p>` | Previous completion item |
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm completion |
| `<C-e>` | Abort completion |
| `<Tab>` | Expand snippet / jump forward |
| `<S-Tab>` | Jump backward in snippet |

---

## Editing

| Key | Action |
|-----|--------|
| `<M-Down>` (Alt+↓) | Move line down |
| `<M-Up>` (Alt+↑) | Move line up |
| `<M-S-Down>` (Alt+Shift+↓) | Duplicate line down |
| `<M-S-Up>` (Alt+Shift+↑) | Duplicate line up |
| `<C-/>` | Toggle comment (supports `[count]` lines) |
| `gcc` | Toggle comment on current line |
| `gc<motion>` | Toggle comment over motion |
| `<leader>f` | Format buffer |

Auto-pairs are enabled for `()`, `[]`, `{}`, `''`, `""`.
Auto-save fires on `InsertLeave` and `TextChanged`.

---

## Motion (Flash)

| Key | Mode | Action |
|-----|------|--------|
| `s` | Normal, Operator | Flash jump (label-based hop) |
| `S` | Normal, Operator | Flash treesitter node select |

---

## Diagnostics

Diagnostics appear inline and as a float on `CursorHold` automatically.

| Key | Action |
|-----|--------|
| `<leader>q` | Send diagnostics to quickfix list |

---

## Terminal

| Key | Action |
|-----|--------|
| `<Esc>` / `<Esc><Esc>` | Exit terminal mode |

---

## Misc

| Key | Action |
|-----|--------|
| `<Esc>` | Clear search highlight |
| `<leader>tt` | Toggle theme (dark Mocha ↔ light Latte) |
| `:Q` | Force quit all windows (`qa!`) |

---

## Disabled intentionally

- **Visual mode** — `v`, `V`, `<C-v>`, `gv` are all no-ops.
- **Mouse clicks/drag** — only scroll wheel works; all click and drag events are suppressed.
- **`<F1>`** — disabled (prevents accidental help window).
