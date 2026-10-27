return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && npm install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_echo_preview_url = 1
    if vim.fn.executable("cmux") == 1 then
      vim.cmd([[
        function! MkdpOpenInCmux(url)
          call jobstart(['cmux', 'browser', 'open-split', a:url])
        endfunction
      ]])
      vim.g.mkdp_browserfunc = "MkdpOpenInCmux"
    end
  end,
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown preview in browser (toggle)" },
  },
  ft = { "markdown" },
}
