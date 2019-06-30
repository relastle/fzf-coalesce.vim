# fzf-coalesce

<img width="756" alt="coalessce-sample" src="https://user-images.githubusercontent.com/6816040/60395179-a3e45680-9b6a-11e9-8048-4b55cb438910.png">

This plugin provides united interface for [fzf-vim](https://github.com/junegunn/fzf.vim)'s following commands
- Buffers
- GFiles
- History
with nerdfont icons powered by [taggo](https://github.com/relastle/taggo).

## Installation

`fzf-coalesce` requires `taggo` command, so please install [taggo](https://github.com/relastle/taggo).
```sh
go get -u https://github.com/relastle/taggo
```

Install (vim-plug)

```sh
# install fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
# install fzf-coalesce
Plug 'relastle/fzf-coalescevim'
```
## Usage

Map `FzfCoalesce` command to some key.
Personally, I mapped it to <kbd>Space</kbd> + <kbd>,</kbd>.

```vim
nnoremap <Space>, :<C-u>FzfCoalesce<CR>
```

## Configuration

Default configurations are like this.

```vim
" Delimiter used to seperate tag and original line
let g:fzf_coalesce_tag_delimiter = "\t"

" Delimiter used to seperate icon and file path
" Note that this must not included g:fzf_coalesce_tag_delimiter
let g:fzf_coalesce_icon_delimiter = "  "

" Dictionary that map source name to tag
let g:fzf_coalesce_tag_dict = {
  \ 'buf': "|BUF|",
  \ 'git': "|GIT|",
  \ 'mru': "|MRU|",
  \ }

" Dictionary that map source name to tag color
let g:fzf_coalesce_tag_color_dict = {
  \ 'buf': "green",
  \ 'git': "yellow",
  \ 'mru': "blue",
  \ }
```

You can change these variables manually.

## [License](LICENSE)

The MIT License (MIT)
