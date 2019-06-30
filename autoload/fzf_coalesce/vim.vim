" plugin/fzf_custom.vim
" Copyright (c) 2017 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

let s:TYPE = {'dict': type({}), 'funcref': type(function('call')), 'string': type(''), 'list': type([])}

function! s:wrap(name, opts, bang)
  " fzf#wrap does not append --expect if sink or sink* is found
  let opts = copy(a:opts)
  let options = ''
  if has_key(opts, 'options')
    let options = type(opts.options) == s:TYPE.list ? join(opts.options) : opts.options
  endif
  if options !~ '--expect' && has_key(opts, 'sink*')
    let Sink = remove(opts, 'sink*')
    let wrapped = fzf#wrap(a:name, opts, a:bang)
    let wrapped['sink*'] = Sink
  else
    let wrapped = fzf#wrap(a:name, opts, a:bang)
  endif
  return wrapped
endfunction

if v:version >= 704
  function! s:function(name)
    return function(a:name)
  endfunction
else
  function! s:function(name)
    " By Ingo Karkat
    return function(substitute(a:name, '^s:', matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunction$'), ''))
  endfunction
endif

let s:default_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

function! s:action_for(key, ...)
  let default = a:0 ? a:1 : ''
  let Cmd = get(get(g:, 'fzf_action', s:default_action), a:key, default)
  return type(Cmd) == s:TYPE.string ? Cmd : default
endfunction

function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction

function! s:get_git_root()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

" Copyright (c) 2019 Hiroki Konishi <relastle@gmail.com>
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
"

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

" Get src_name (`buf`, `git`, or `mru`) for
" a given tag
function! s:get_src_name(tag)
  for k in keys(g:fzf_coalesce_tag_dict)
    if g:fzf_coalesce_tag_dict[k] == a:tag
      return k
    endif
  endfor
  return ""
endfunction

" Build external `taggo` commnad to decorate lines for
" given src_name (`buf`, `git`, or `mru`)
function! s:build_taggo_cmd(src_name)
  return "taggo " .
        \ "--tag '" . get(g:fzf_coalesce_tag_dict, a:src_name, "src_name") . "' " .
        \ "--tag-color '" . get(g:fzf_coalesce_tag_color_dict, a:src_name, "black") . "' " .
        \ "--tag-delimiter '" . g:fzf_coalesce_tag_delimiter . "' " .
        \ "--icon-indices 0 " .
        \ "--icon-delimiter '" . g:fzf_coalesce_icon_delimiter . "' "
endfunction

" Get external commnad that echos
" \n-joined lines from vimL list
function! s:get_echo_cmd(lst)
  return 'bash -c "echo -e \"' . join(a:lst, "\n") . '\""'
endfunction

" Handler to be invoked after a line
" is selected by `fzf` interface
function! s:after_select(lines)
  if len(a:lines) < 2
    return
  endif
  let cmd = s:action_for(a:lines[0])
  if !empty(cmd)
    execute 'silent' cmd
  endif
  let target_line = a:lines[1]
  let tag = split(target_line, g:fzf_coalesce_tag_delimiter)[0]
  let src_name = s:get_src_name(tag)
  let revert_cmd = s:build_taggo_cmd(src_name) . "--revert"
  let after = system(s:get_echo_cmd([target_line]) . ' | ' . revert_cmd)
  execute 'e' after
endfunction

" Get list of current opened buffers
function! s:get_bufs()
  return filter(map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'), 'strlen(v:val)')
endfunction

" Get list of (M)ost (R)ecently (U)sed files
function! s:get_mrus()
  return map(filter([expand('%')], 'len(v:val)')
        \  + filter(copy(v:oldfiles), "filereadable(fnamemodify(v:val, ':p'))"),
        \  'fnamemodify(v:val, ":~:.")')
endfunction

" Get external shell command that outputs buffers list.
function! s:get_buf_source()
  let bufs = s:get_bufs()
  if len(bufs) == 0
    return ':;'
  else
    return s:get_echo_cmd(bufs) . ' | ' . s:build_taggo_cmd('buf') . ';'
  endif
endfunction

" Get external shell command that outputs git-tracked list.
function! s:get_git_source()
  let root = s:get_git_root()
  if empty(root)
    return ':;'
  else
    return 'git ls-files ' . root . ' | ' . s:build_taggo_cmd('git') . ';'
  endif
endfunction

" Get external shell command that outputs MRU files.
function! s:get_mru_source()
  let mrus = s:get_mrus()
  if len(mrus) == 0
    return ':;'
  else
    return s:get_echo_cmd(mrus) . ' | ' . s:build_taggo_cmd('mru') . ';'
  endif
endfunction

function! fzf_coalesce#vim#coalesce()
  let source = s:get_buf_source() . s:get_git_source() . s:get_mru_source()
  call fzf#run(s:wrap(
        \ 'coalesce',
        \ {
        \   'source'  : source,
        \   'sink*' : function('s:after_select'),
        \   'options' : [
        \     '--ansi',
        \     '-d', g:fzf_coalesce_tag_delimiter,
        \     '-n', '2..',
        \   ],
        \ },
        \ 0
        \ ))
endfunction
