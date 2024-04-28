return {
  "hrsh7th/nvim-cmp",
  dependencies = { "Exafunction/codeium.nvim" },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    table.insert(opts.sources, { name = "codeium" })
  end,
}
