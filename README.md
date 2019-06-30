# fzf-coalesce

This plugin provides united interface for [fzf-vim](https://github.com/junegunn/fzf.vim)'s following commands
- Buffers
- GFiles
- History
with nerdfont icons powered by [taggo](https://github.com/relastle/taggo).

| vim | neovim(using floating window) |
| --- | ---                           |
| <img width="1108" alt="vim" src="https://user-images.githubusercontent.com/6816040/60395669-ed846f80-9b71-11e9-88a8-74a6df705046.png"> | <img width="1107" alt="neovim_floating_window" src="https://user-images.githubusercontent.com/6816040/60395670-ef4e3300-9b71-11e9-93be-3b1452a277f8.png"> |

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
