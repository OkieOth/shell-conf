return {
  {
    "tyru/open-browser.vim",
    lazy = false,
  },
  {
    "aklt/plantuml-syntax",
    ft = { "plantuml", "puml" },
  },
  {
    "weirongxu/plantuml-previewer.vim",
    ft = { "plantuml", "puml" },
    keys = {
      { "<leader>po", "<cmd>PlantumlOpen<cr>", desc = "Opens Plantuml diagram in browser" },
      { "<leader>ps", "<cmd>PlantumlSave<cr>", desc = "Save Plantuml diagram" },
    },
  },
}
