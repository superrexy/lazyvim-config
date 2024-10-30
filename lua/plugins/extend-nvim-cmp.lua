return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")

    -- Disable autocompletion
    opts.completion = vim.tbl_extend("force", opts.completion, {
      autocomplete = false,
    })

    -- Allow to show the completion menu with <C-Space>
    opts.mapping = vim.tbl_extend("force", opts.mapping, {
      ["C-Space"] = cmp.mapping.complete(),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        else
          fallback()
        end
      end, { "i", "s" }),
    })

    -- Remove the copilot source
    for i, source in ipairs(opts.sources) do
      if source.name == "copilot" then
        table.remove(opts.sources, i)
        break
      end
    end
  end,
}
