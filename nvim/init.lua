-- Entry point. Keep this thin.
--
-- Editor options live in lua/config/options.lua (LazyVim loads it before
-- lazy.setup evaluates plugin specs — `mapleader` and other "must be set
-- before plugins" globals belong there, not here).
-- Autocmds live in lua/config/autocmds.lua (loaded on the VeryLazy event).
-- Keymaps live in lua/config/keymaps.lua and per-plugin lazy specs.
require("config.lazy")
