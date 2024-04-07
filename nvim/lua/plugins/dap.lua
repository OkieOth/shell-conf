return {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<leader>dPt",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Python run current test",
    },
  },
  config = function()
    vim.api.nvim_set_hl(0, "blue", { fg = "#fb09ae" })
    vim.fn.sign_define("DapBreakpoint", { text = "✪", texthl = "blue", linehl = "blue", numhl = "" })
  end,
}
