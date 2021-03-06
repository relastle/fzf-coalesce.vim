" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
"
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'relastle/fzf-coalesce.vim'
call plug#end()

nnoremap <Space>, :<C-u>FzfCoalesce<CR>
