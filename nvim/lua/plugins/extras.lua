return {
{
  'vyfor/cord.nvim',
  build = ':Cord update',
  -- opts = {}
},
{
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end
}
}
