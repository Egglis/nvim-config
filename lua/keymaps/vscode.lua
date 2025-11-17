local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

return function()
    keymap({ "n", "v" }, "K", "<cmd>lua require('vscode').action('editor.action.moveLinesUpAction')<cr>")
    keymap({ "n", "v" }, "J", "<cmd>lua require('vscode').action('editor.action.moveLinesDownAction')<cr>")

    -- VS-code plugin 
    keymap({ "n", "v" }, "<leader>fa", "<cmd>lua require('vscode').action('periscope.search')<CR>")
    keymap({ "n", "v" }, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")
    keymap({ "n", "v" }, "<leader>fa", "<cmd>lua require('vscode').action('periscope.search')<CR>")
    keymap({ "n", "v" }, "<leader>ff", "<cmd>lua require('vscode').action('periscope.searchCurrentFile')<CR>")
    keymap({ "n", "v" }, "<leader>ku", "<cmd>lua require('vscode').action('editor.action.removeCommentLine')<CR>")
    keymap({ "n", "v" }, "<leader>kc", "<cmd>lua require('vscode').action('editor.action.addCommentLine')<CR>")
    keymap({ "n", "v" }, "<leader>gr", "<cmd>lua require('vscode').action('editor.action.goToReferences')<CR>")

    -- Change focus
    keymap("n", "<leader>fe", "<cmd>lua require('vscode').action('workbench.files.action.focusFilesExplorer')<CR>")
    keymap("n", "<leader>fg", "<cmd>lua require('vscode').action('workbench.view.scm')<CR>")

    -- Harpoon
    keymap({"n", "v"}, "<leader>ha", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>")
    keymap({"n", "v"}, "<leader>hh", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>")
    keymap({"n", "v"}, "<leader>he", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>")
    keymap({"n", "v"}, "<leader>h1", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor1')<CR>")
    keymap({"n", "v"}, "<leader>h2", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor2')<CR>")
    keymap({"n", "v"}, "<leader>h3", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor3')<CR>")
    keymap({"n", "v"}, "<leader>h4", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>")
    keymap({"n", "v"}, "<leader>h5", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor5')<CR>")
    keymap({"n", "v"}, "<leader>h6", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor6')<CR>")
    keymap({"n", "v"}, "<leader>h7", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor7')<CR>")
    keymap({"n", "v"}, "<leader>h8", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor8')<CR>")
    keymap({"n", "v"}, "<leader>h9", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor9')<CR>")

    -- List files
    keymap({"n", "v"}, "<leader>le", "<cmd>lua require('vscode').action('workbench.action.showAllEditors')<CR>")
    keymap({"n", "v"}, "<leader>ee", "<cmd>lua require('vscode').action('workbench.action.focusLeftGroup')<CR>")
    keymap({"n", "v"}, "<leader>bb", "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>")

    -- Terminal stuff
    keymap({"n", "v"}, "<leader>tt", "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>")
    keymap({"n", "v"}, "<leader>tr", "<cmd>lua require('vscode').action('workbench.action.positionPanelRight')<CR>")
    keymap({"n", "v"}, "<leader>tb", "<cmd>lua require('vscode').action('workbench.action.positionPanelBottom')<CR>")
end