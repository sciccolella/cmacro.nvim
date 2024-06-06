local M = {}

local function toggle_comment(current_line)
  local non_blank = current_line:match("^%s*"):len()
  local new_line = ""
  if current_line:match("/[*]") then
    new_line = string.gsub(current_line, "/[*]", "")
    new_line = string.gsub(new_line, "[*]/", "")
  else
    new_line = string.gsub(current_line, "\\", "")
    new_line = string.gsub(new_line, "^%s*(.-)%s*$", "%1")
    new_line = string.sub(current_line, 1, non_blank) .. "/* " .. new_line .. " */ \\"
  end
  return new_line
end

local function toggle_linebreak(current_line)
  local new_line = ""
  if current_line:match("\\%s*$") then
    new_line = string.gsub(current_line, "\\%s*$", "")
    new_line = string.gsub(new_line, "^(%s*.-)%s*$", "%1")
  else
    new_line = current_line .. " \\"
  end
  return new_line
end

local function visual_selection_map_substitute(transform)
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "␖" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  local n = cerow - csrow + 1
  for i = 1, n, 1 do
    local new_line = transform(lines[i])
    vim.api.nvim_buf_set_lines(0, csrow + i - 2, csrow + i - 1, true, { new_line })
  end
end

function M.cmacro_comment_toggle_visual_line()
  visual_selection_map_substitute(toggle_comment)
end

function M.cmacro_comment_toggle_single_line()
  local current_line = vim.api.nvim_get_current_line()
  local new_line = toggle_comment(current_line)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row - 1, row, true, { new_line })
end

function M.cmacro_linebreak_toggle_visual_line()
  visual_selection_map_substitute(toggle_linebreak)
end

function M.cmacro_lineabreak_toggle_single_line()
  local current_line = vim.api.nvim_get_current_line()
  local new_line = toggle_linebreak(current_line)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_lines(0, row - 1, row, true, { new_line })
end

function M.setup()
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
end

return M
