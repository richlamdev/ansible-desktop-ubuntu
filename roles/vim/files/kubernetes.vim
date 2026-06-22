augroup filetypedetect_kubernetes
    autocmd!
    autocmd BufNewFile,BufRead *.yaml,*.yml call s:DetectKubernetes()
augroup END

function! s:DetectKubernetes()
    " Scan the first 50 lines of the file for K8s identifiers
    let l:lines = getline(1, 50)
    for l:line in l:lines
        if l:line =~# '^\s*apiVersion:\s*.*' || l:line =~# '^\s*kind:\s*.*'
            set filetype=yaml.kubernetes
            return
        endif
    endfor
endfunction
