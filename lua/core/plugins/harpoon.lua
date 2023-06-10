local M = {
  "ThePrimeagen/harpoon",
  keys = {
    {
      "<leader>ha",
      function()
        require("harpoon.mark").add_file()
      end,
      desc = "Add File",
    },
    {
      "<leader>hm",
      function()
        require("harpoon.ui").toggle_quick_menu()
      end,
      desc = "File Menu",
    },
    {
      "<leader>[",
      function()
        require("harpoon.ui").nav_prev()
      end,
      desc = "Harpoon Prev",
    },
    {
      "<leader>]",
      function()
        require("harpoon.ui").nav_next()
      end,
      desc = "Harpoon Next",
    },
  },
  opts = {
    global_settings = {
      save_on_toggle = true,
    },
  },
}

return M
