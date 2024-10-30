-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }

    local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/codeAction" })
    if #clients == 0 then
      return
    end

    local results = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    if not results then
      return
    end

    for _, result in pairs(results) do
      for _, action in pairs(result.result or {}) do
        if action.kind == "source.organizeImports" then
          vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
          vim.wait(100)
          break
        end
      end
    end
  end,
})
