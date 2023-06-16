local nls = require("null-ls")
local h = require("null-ls.helpers")
local u = require("null-ls.utils")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local eslint_d = {
  cwd = h.cache.by_bufnr(function(params)
    return u.root_pattern(
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc.json"
    )(params.bufname)
  end),
}

-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
nls.setup({
  sources = {
    nls.builtins.formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),

    -- eslint_d
    nls.builtins.diagnostics.eslint_d.with(eslint_d),
    nls.builtins.code_actions.eslint_d.with(eslint_d),
    nls.builtins.formatting.eslint_d.with(eslint_d),
    -- prettier_eslint
    -- nls.builtins.formatting.prettier_eslint,
    -- prettier_d
    -- nls.builtins.formatting.prettierd,

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
