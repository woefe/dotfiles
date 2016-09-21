if has('nvim')
    nnoremap <leader>ll :call jobstart(['markdownmk', expand('%')])<CR>
endif
