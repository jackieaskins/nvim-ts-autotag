local _, ts_utils = pcall(require, 'nvim-treesitter.ts_utils')

local filetypes = {
  'javascript', 'javascriptreact', 'javascript.jsx',
  'typescript', 'typescriptreact', 'typescript.jsx', 'typescript.tsx'
}

local function is_jsx()
  return vim.tbl_contains(filetypes, vim.bo.filetype)
end

local M = {}

function M.is_jsx_fragment()
  local current_line = vim.fn.getline('.')
  local previous_col = vim.fn.col('.') - 1
  local current_node = ts_utils.get_node_at_cursor()

  if not is_jsx() or previous_col < 1 or (current_node and current_node:type() == 'string') then
    return false
  end

  local previous_char = string.sub(current_line, previous_col, previous_col)

  if previous_char ~= '<' then return false end
  if previous_col == 1 then return true end

  local before_char = string.sub(current_line, previous_col - 1, previous_col - 1)

  return vim.tbl_contains({'(', ' ', '>'}, before_char)
end

return M
