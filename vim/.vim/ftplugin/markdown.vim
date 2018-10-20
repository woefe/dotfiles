if has('nvim')
    nnoremap <leader>ll :call jobstart(['markdownmk', expand('%')])<CR>
endif
set colorcolumn&
set textwidth&
autocmd FileType markdown UltiSnipsAddFiletypes tex
