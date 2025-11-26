-- Enhanced neovim configuration for portfolio terminal
-- Simplified version without LSP/Copilot (read-only environment)

-- Basic settings
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true

vim.o.termguicolors = true
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.scrolloff = 8
vim.o.cursorline = true
vim.o.mouse = "a"
vim.o.laststatus = 2

-- Keymaps
local map = vim.keymap.set

-- Semicolon to colon
map("n", ";", ":", { noremap = true })
map("v", ";", ":", { noremap = true })

-- File explorer
map("n", "<leader>e", ":Ex<CR>", { desc = "Open file explorer" })

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Insert blank line
map("n", "<CR>", "m`o<Esc>``", { desc = "Insert line below" })

-- Better scrolling (keep cursor centered)
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-e>", "<C-e>j")
map("n", "<C-y>", "<C-y>k")

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Better search navigation (keep centered)
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- FZF keymaps (if available)
map("n", "<C-p>", ":FZF<CR>", { desc = "Find files", silent = true })
map("n", "<leader>fg", ":Rg<CR>", { desc = "Live grep", silent = true })

-- Try to load plugins (pre-installed in container)
local function safe_require(module)
  local ok, result = pcall(require, module)
  return ok and result or nil
end

-- Treesitter setup (if available)
local treesitter = safe_require("nvim-treesitter.configs")
if treesitter then
  treesitter.setup({
    highlight = { enable = true },
    indent = { enable = true },
  })
end

-- Mini.nvim modules (if available)
local mini_icons = safe_require("mini.icons")
if mini_icons then mini_icons.setup() end

local mini_surround = safe_require("mini.surround")
if mini_surround then
  mini_surround.setup({
    mappings = {
      add = "sa",
      delete = "sd",
      find = "sf",
      find_left = "sF",
      highlight = "sh",
      replace = "sr",
      update_n_lines = "sn",
    },
  })
end

local mini_pick = safe_require("mini.pick")
if mini_pick then
  mini_pick.setup()
  map("n", "<C-p>", "<cmd>Pick files<cr>", { desc = "Find files" })
  map("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Live grep" })
end

-- Oil.nvim (if available)
local oil = safe_require("oil")
if oil then
  oil.setup({
    skip_confirm_for_simple_edits = true,
    keymaps = {
      ["q"] = "actions.close",
      ["<Esc>"] = "actions.close",
    },
  })
  map("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Oil floating" })
end

-- Catppuccin colorscheme (if available), fallback to built-in
local catppuccin_ok = pcall(vim.cmd, "colorscheme catppuccin-macchiato")
if not catppuccin_ok then
  -- Fallback to a nice built-in colorscheme
  pcall(vim.cmd, "colorscheme habamax")
end

-- Custom statusline
vim.o.statusline = " %f %m %r %= %l:%c  %p%% "
