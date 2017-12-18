"----------------------------------------------------------------------
" General
"----------------------------------------------------------------------

    set nocompatible " Avoid using obsolete vi commands
    set number " Show line numbers on the left
    set mouse=a " Scroll, and select without line number in xterm
    set backspace=indent,eol,start " Make BACKSPACE act normally as it's expected
    set encoding=utf8
    set ruler

    autocmd BufWritePre * %s/\s\+$//e "automatically trim trailing white space on save

    " Keep indentation when wrapping long lines
        if has("patch-7.4.354")
            set breakindent
        endif
    " Identify platform, see https://github.com/spf13/spf13-vim
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction

"----------------------------------------------------------------------
" Text, tab and indent related
"----------------------------------------------------------------------

    " Tab settings based on Python, see https://wiki.python.org/moin/Vim
        set expandtab " Convert tabs to spaces;
        set tabstop=8 " How many columns a tab counts for;
        set shiftwidth=4 " How many columns text is indented with the reindent operations (<< and >>);
        set softtabstop=4 " How many columns vim uses when you hit Tab in insert mode.

    " Enable filetype plugins
        if has("autocmd")
            filetype plugin indent on
        endif

    "set foldmethod=indent " Fold codes according to indent when a file is opened

    set autoindent " for those filetypes whose plugins don't indent smartly
        " I add this due to Haskell. See http://vim.wikia.com/wiki/Indenting_source_code

"----------------------------------------------------------------------
" Compile & Run
"----------------------------------------------------------------------

    " See http://blog.chinaunix.net/uid-21202106-id-2406761.html
    func! CleanScreen()
        if !has('gui_running')
            if WINDOWS()
                exec "silent !cls"
            else
                exec "silent !clear"
            endif
        endif
    endfunc

    func! CompileCode()
        exec "w"
        exec "call CleanScreen()"
        if &filetype == "cpp"
            exec "!g++ % -o %<"
        elseif &filetype == "c"
            exec "!gcc % -o %<"
        elseif &filetype == "python"
            exec "!python %"
        elseif &filetype == "java"
            exec "!javac %"
        elseif &filetype == "haskell"
            exec "!ghci %"
        endif
    endfunc

    func! RunResult()
        exec "w"
        exec "call CleanScreen()"
        if &filetype == "cpp"
            exec "! ./%<"
        elseif &filetype == "c"
            exec "! ./%<"
        elseif &filetype == "python"
            exec "!python %"
        elseif &filetype == "java"
            "exec "!java %<"
            exec "!java %:t:r"
                "This version fixes the problem in vim ./Something.java
        endif
    endfunc

    map <F5> :call CompileCode()<CR>
    imap <F5> <ESC>:call CompileCode()<CR>
    vmap <F5> <ESC>:call CompileCode()<CR>

    map <F6> :call RunResult()<CR>

"----------------------------------------------------------------------
" GUI Settings
"----------------------------------------------------------------------

    " See https://github.com/spf13/spf13-vim

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        "set lines=40                " 40 lines of text instead of 24
        if LINUX()
            set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
        elseif OSX()
            set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        elseif WINDOWS()
            set guifont=Andale_Mono:h14,Menlo:h14,Consolas:h13,Courier_New:h14
        endif

        " Map Ctrl-C, Ctrl-V, Ctrl-X
        vmap <C-c> "+y
        vmap <C-x> "+d
        vmap <C-v> c<ESC>"+p
        imap <C-v> <C-r><C-o>+
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

"----------------------------------------------------------------------
" Colors
"----------------------------------------------------------------------

    " Ensure the background is dark and using the best DESERT color scheme
        set background=dark
        try
            colorscheme desert
        catch
        endtry

    " Enable syntax highlighting
        if has("syntax")
            syntax on
        endif

    " Hightlight trailing white spaces
        " These settings might be overwritten by colorscheme command, so they are
        " put after colorscheme settings.
        " See http://vim.wikia.com/wiki/Highlight_unwanted_spaces
        " highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
        " match ExtraWhitespace /\s\+$/

    " Change the colour of line numbers
        " Make the line number colour less obtrusive.
        " Should be placed after other color settings.
        highlight LineNr ctermfg=DarkGrey guifg=DarkGrey
        " The full version of the setting can be:
        "highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
        highlight Comment ctermfg=DarkGrey guifg=DarkGrey

