-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("n", "<leader>nt", "<cmd>Neotree toggle<cr>", { desc = "Toggle NeoTree window" })

-- Buffer movements
vim.keymap.set("n", "<C-PageUp>", "<cmd>bprevious<cr>", { desc = "Next buffer left" })
vim.keymap.set("n", "<C-PageDown>", "<cmd>bnext<cr>", { desc = "Next buffer right" })

-- Window movements
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Next window left" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Next window right" })

-- Change window size
vim.keymap.set("n", "<leader>+", "<cmd>vertical resize +2<cr>")
vim.keymap.set("n", "<leader>-", "<cmd>vertical resize -2<cr>")
