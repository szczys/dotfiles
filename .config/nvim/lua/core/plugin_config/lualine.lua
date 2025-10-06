-- Custom red dot when file has been modified
local custom_fname = require('lualine.components.filename'):extend()
local highlight = require'lualine.highlight'

function custom_fname:init(options)
  custom_fname.super.init(self, options)
  self.status_colors = {
    saved = highlight.create_component_highlight_group(
      {bg = nil}, 'filename_status_saved', self.options),
    modified = highlight.create_component_highlight_group(
      {fg = '#ff0000'}, 'filename_status_modified', self.options),
  }
  if self.options.color == nil then self.options.color = '' end
end

function custom_fname:update_status()
  local data

  if vim.bo.modified then
    data = highlight.component_format_highlight(vim.bo.modified
                                                and self.status_colors.modified
                                                or self.status_colors.saved) .. ""
    return data
  else
    return ' '
  end
end
-- end custom red dot when file has been modified

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
  },
  sections = {
    lualine_b = { 'filename' },
    lualine_c = { custom_fname },
  }
}
