local nls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

nls.setup({
  sources = {
    nls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),

    -- eslint
    nls.builtins.diagnostics.eslint,
    nls.builtins.code_actions.eslint,
    nls.builtins.formatting.eslint,

    nls.builtins.formatting.terraform_fmt,

    nls.builtins.formatting.black,
    nls.builtins.formatting.goimports,
    nls.builtins.formatting.gofumpt,
    nls.builtins.formatting.latexindent.with({
      extra_args = { "-g", "/dev/null" }, -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
    }),
    nls.builtins.code_actions.shellcheck,
    nls.builtins.code_actions.gitsigns,
    nls.builtins.formatting.shfmt,
    nls.builtins.diagnostics.ruff,
    nls.builtins.formatting.rustfmt,
  },
  on_attach = function(client, bufnr)
    vim.keymap.set(
      "n",
      "<leader>tF",
      "<cmd>lua require('core.plugins.lsp.utils').toggle_autoformat()<cr>",
      { desc = "Toggle format on save" }
    )
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          if AUTOFORMAT_ACTIVE then -- global var defined in functions.lua
            vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 10000 })
          end
        end,
      })
    end
  end,
})
