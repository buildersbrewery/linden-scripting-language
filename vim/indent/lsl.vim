" indent/lsl.vim

setlocal indentexpr=lslIndent()

function! LSLIndent()
    let line = getline(v:lnum)
    let previousNum = prevnonblank(v:lnum - 1)
    let previousLine = getline(previousNum)

    if previousLine =~ "{" && previous !~ "}" && line !~ "}" && line !~ ":$"
        return indent(previousNum) + &tabstop
    endif

endfunction
