if exists('did_plugin_fzf_coalesce') || &cp
    finish
endif
let did_plugin_fzf_coalesce=1

command! -nargs=0 FzfCoalesce call fzf_coalesce#vim#coalesce()
