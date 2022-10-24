-- How to debug
-- print(vim.inspect(o.clipboard))
-- :luafile %

local o = vim.o

-- unnamedplus is used for clipboard on MacOS and Windows
-- unamed is used for selection on Linux
o.clipboard = 'unnamed,unnamedplus'


o.number = true -- show line numbers
o.relativenumber = true -- show relative numbers by default

-- show absolute numbers in insert mode, relative in normal mode
vim.cmd([[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  augroup END
]])

o.showmatch = true -- show matching brackets

o.smartindent = true -- use c-like indents when no indentexpr is used
o.expandtab = true -- use spaces instead of tabs
o.shiftwidth = 2 -- use 2 spaces when inserting tabs
o.tabstop = 2 -- show tabs as 2 spaces

o.splitright = true -- vsplit to right of current window
o.splitbelow = true -- hsplit to bottom of current window

o.hidden = true -- allow background buffers

o.scrolloff = 2 -- include 2 rows of context above/below current line
o.sidescrolloff = 5 -- include 5 colums of context to the left/right of current column

o.ignorecase = true -- ignore case in searches...
o.smartcase = true -- ...unless we use mixed case

o.joinspaces = false -- join lines without two spaces

o.cursorline = true

term = os.getenv("TERM")
if string.find(term, "tmux") or string.find(term, "iterm") then
    o.termguicolors = true -- allow true colors
end

o.inccommand = "nosplit" -- show effects of substitute incrementally

-- enable this will enable copying from mouse selection
-- o.mouse = "i" -- enable mouse mode

o.updatetime = 400 -- decrease time for cursorhold event
o.timeoutlen = 500
