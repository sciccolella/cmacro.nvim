# cmacro
Plugin to perform common operations on `c/c++` macro editing:
    - Toggle linebreak at the end of line(s)
    - Toggle comments inline in in-macro lines

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "sciccolella/cmacro.nvim",
    config = function()
        require("cmacro").setup()
    end,
    ft = { "c", "cpp" },
    lazy = true,
}
```

## Keymaps
```lua
  vim.keymap.set("n", "gm", M.cmacro_comment_toggle_single_line, { desc = "c[M]acro toggle in-macro comment" })
  vim.keymap.set("v", "gm", M.cmacro_comment_toggle_visual_line, { desc = "c[M]acro toggle in-macro comment" })
  vim.keymap.set(
    "n",
    "<leader>ml",
    M.cmacro_lineabreak_toggle_single_line,
    { desc = "c[M]acro toggle macro [L]inebreak" }
  )
  vim.keymap.set(
    "v",
    "<leader>ml",
    M.cmacro_linebreak_toggle_visual_line,
    { desc = "c[M]acro toggle macro [L]inebreak" }
  )
```
## Examples

```c 
#define test(x, y)                                                             \
  do {                                                                         \
    int zx = 21;                                                               \
    typeof(y) yy = 0;                                                          \
    yy += x;                                                                   \
  } while (0)

// Inline in-macro comment on line 4 [gm] in either normal or visual mode

#define test(x, y)                                                             \
  do {                                                                         \
    int zx = 21;                                                               \
    typeof(y) yy = 0;                                                          \
    /* yy += x; */                                                             \
  } while (0)
```
