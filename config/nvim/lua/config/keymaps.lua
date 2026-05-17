local map = vim.keymap.set

local function switch_source_header()
  local clangd_attached = false
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    if client.name == "clangd" then
      clangd_attached = true
      break
    end
  end

  if not clangd_attached then
    vim.notify("clangd is not attached to this buffer", vim.log.levels.WARN)
    return
  end

  local params = { uri = vim.uri_from_bufnr(0) }

  vim.lsp.buf_request(0, "textDocument/switchSourceHeader", params, function(err, result)
    if err then
      vim.notify(err.message or "Unable to switch source/header", vim.log.levels.ERROR)
      return
    end

    if not result or result == "" then
      vim.notify("No matching source/header file found", vim.log.levels.WARN)
      return
    end

    vim.cmd.edit(vim.uri_to_fname(result))
  end)
end

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "File explorer" })
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
map("n", "<leader>=", "gg=G``", { desc = "Reindent buffer" })
map("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })
map("x", "<Tab>", ">gv", { desc = "Indent selection" })
map("x", "<S-Tab>", "<gv", { desc = "Unindent selection" })
map("x", ">", ">gv", { desc = "Indent selection" })
map("x", "<", "<gv", { desc = "Unindent selection" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
map("n", "<leader>tt", "<cmd>TodoTelescope<cr>", { desc = "TODOs" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Debug continue" })
map("n", "<leader>dn", function() require("dap").step_over() end, { desc = "Debug next" })
map("n", "<leader>di", function() require("dap").step_into() end, { desc = "Debug step into" })
map("n", "<leader>do", function() require("dap").step_out() end, { desc = "Debug step out" })
map("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Debug terminate" })
map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Debug REPL" })
map("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Debug UI" })
map("n", "<leader>cm", "<cmd>CMakeGenerate<cr>", { desc = "CMake generate" })
map("n", "<leader>cb", "<cmd>CMakeBuild<cr>", { desc = "CMake build" })
map("n", "<leader>cr", "<cmd>CMakeRun<cr>", { desc = "CMake run" })
map("n", "<leader>ct", "<cmd>CMakeSelectBuildType<cr>", { desc = "CMake build type" })
map("n", "<leader>cT", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "CMake build target" })
map("n", "<leader>cl", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "CMake launch target" })
map("n", "<leader>cp", "<cmd>CMakeSelectConfigurePreset<cr>", { desc = "CMake configure preset" })
map("n", "<leader>cP", "<cmd>CMakeSelectBuildPreset<cr>", { desc = "CMake build preset" })
map("n", "<leader>cd", "<cmd>CMakeDebug<cr>", { desc = "CMake debug" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
    map("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format" }))
    map("n", "<leader>ch", switch_source_header, vim.tbl_extend("force", opts, { desc = "Switch source/header" }))
    map("n", "<leader>th", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
    end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
    map("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", vim.tbl_extend("force", opts, { desc = "Document symbols" }))
    map("n", "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
    map("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
    map("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
  end,
})
