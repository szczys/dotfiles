return {
    'jakewvincent/mkdnflow.nvim',
    config = function()
      require('mkdnflow').setup({
          links = {
              transform_explicit = function(text)
                  return ''
              end
          }
      })
    end
}
