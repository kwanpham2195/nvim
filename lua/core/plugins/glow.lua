return {
  "ellisonleao/glow.nvim",
  event = "VeryLazy",
  config = function()
    require("glow").setup()
  end,
  cmd = "Glow",
}
