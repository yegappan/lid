" File: lid.vim
" Author: Yegappan Lakshmanan
" Version: 2.3
" Last Modified: Sep 18 2002
" 
" Overview
" --------
" The lid.vim Vim plugin provides a way to interact with the lid tool to
" lookup keywords in the ID database.
" 
" For more information about id utilities (lid, aid, etc), visit the 
" following pages: 
"
"     http://www.delorie.com/gnu/docs/id-utils/id-utils_toc.html 
"     http://www.gnu.org/software/idutils/idutils.html 

" You can download the id-utils binaries for Windows from: 
"
"     http://www.mossbayeng.com/~ron/vim/idutils.tar.gz
" 
" Installation
" ------------
" 1. Copy the lid.vim file to the $HOME/.vim/plugin directory.  Refer to
"    ':help add-plugin', ':help add-global-plugin' and ':help runtimepath' for
"    more details about Vim plugins.
" 2. Set the LID_Cmd variable to point to the lid utility path.
" 3. Restart Vim.
" 4. You can use the ":Lid" command to search for a keyword.
"
" This plugin will not work in 'compatible' mode.  Make sure the 'compatible'
" option is not set.
"
" Usage
" -----
" You can lookup keywords in the ID database using the 'Lid' command. For
" example,
" 
"       :Lid<Enter> 
" 
" This will prompt you for the keyword to lookup.  The default is the current
" keyword under the cursor.  You can retrieve previously entered keywords
" using the up and down arrow keys. You can cancel the lookup by pressing the
" escape key.
"
" You can map a key to invoke the Lid command:
"
"       nnoremap <silent> <F4> :Lid<CR>
"
" Add the above mapping to your ~/.vimrc file.
" 
" You can also specify the keyword to the Lid command like this:
" 
"       :Lid <keyword>
" 
" In the above command format, you can press the <Tab> key to expand
" keywords from a tags file.
"
" You can use the "-p" and "-v" option to the 'Lid' command to selectively
" display lines from the lid output. You can use the "-p" option to the 'Lid'
" command to list only those lid matches that contain a pattern. You can use
" the "-v" option to the 'Lid' command to list only those lid matches that
" does not contain a pattern. Only one of the "-p" or "-v" options can be used
" at a time.
"
"        :Lid -p
"        :Lid -v
"
" If you use the any one of the above options, you will prompted to enter the
" pattern you are interested in.
" 
" The output of the lid command will be listed in the Vim quickfix window.
" 1. You can select a line in the quickfix window and press <Enter> or double
"    click on a match to jump to that line.
" 2. You can use the ":cnext" and ":cprev" commands to the jump to the next or
"    previous output line.
" 3. You can use the ":colder" and ":cnewer" commands to go between multiple
"    Lid quickfix output windows.
" 4. The quickfix window need not be opened always to use the lid output.
"    You can close the quickfix window and use the quickfix commands to jump
"    to the lid matches.  Use the ":copen" command to open the quickfix
"    window again.
"
" For more information about other quickfix commands read ":help quickfix"
" 
" Configuration
" -------------
" By changing the following variables you can configure the behavior of this
" plugin. Set the following variables in your .vimrc file using the 'let'
" command.
"
" The path to the lid executable is specified by the 'LID_Cmd' variable.  By
" default, this variable is set to lid. You can change the lid executable path
" by setting the 'LID_Cmd' variable:
"
"       let LID_Cmd = '/my/path/lid'
" 
" By default, this plugin uses 'ID' as the name of the database.  This is
" defined by the 'LID_File' variable.  You can change the name/location of the
" ID database by setting the 'LID_File' variable:
"
"       let LID_File = '/my/path/ID'
"
" You can also specify more than one ID file names in the LID_File variable.
" The ID file names should be separated by a ',' character.
"
"       let LID_File = '/my/path1/ID,/my/path2/ID,/my/path3/ID'
"
" The plugin will use the first ID file name and run lid using that filename.
" If a match is found, it will return the results. If a match is not found,
" then the second ID file name will be used and this will be repeated till
" either a match is found or all the specified ID file names are processed.
"
" If more than one ID file is specified using the 'LID_File' variable, you can
" set the 'LID_Search_Multiple_ID_Files' variable to 1 to always search for a
" keyword in all the specified ID files. By default,
" 'LID_Search_Multiple_ID_Files' variable is set to zero. When a match is
" found in one of the specified ID files, subsequent ID files are not searched
" for the keyword.
"
"       let LID_Search_Multiple_ID_Files = 1
" 
" By default, when you invoke the :Lid command the quickfix window will be
" opened with the lid output.  You can disable opening the quickfix window,
" by setting the 'LID_OpenQuickfixWindow' variable to 1:
"
"       let LID_OpenQuickfixWindow = 1
"
" You can manually open the quickfix window using the :cwindow command.
"
" The 'LID_Shell_Quote_Char' variable specifies the character to use to
" escape the keyword before passing it to the lid command.  By default,
" for MS-Windows systems, no shell quote character is set.  For other
" systems, "'" is used as the the shell quote character.  You can change
" this by setting the 'LID_Shell_Quote_Char' variable:
"
"       let LID_Shell_Quote_Char = '"'
"
" By default, the ID file specified by the LID_File variable will be used.  If
" you set the 'LID_Prompt_ID_Filename' variable to 1, then every time the LID
" command will prompt for the location of the ID file.  The default ID file
" location displayed will be the last used value.  You can again set the
" 'LID_Prompt_ID_Filename' variable back to 0, to turn off this prompt.  The
" last supplied ID file will be used for further Lid invocations.
"
"       let LID_Prompt_ID_Filename = 1
"
" By default, when the lid output is displayed, the cursor will be
" automatically positioned at the first matching line.  You can set the
" LID_Jump_To_Match variable to 0 to prevent this.  In this case, only the
" output from LID will be displayed.
"
"       let LID_Jump_To_Match = 0
"
"
" --------------------- Do not modify after this line ---------------------
if exists('loaded_lid') || &cp
    finish
endif
let loaded_lid = 1

" The default location of the lid tool.
if !exists('LID_Cmd')
    let LID_Cmd = 'lid'
endif

" Name of the ID file to supply to lid
if !exists('LID_File')
    let LID_File = 'ID'
endif

" Combine matches from more than one ID file?
if !exists('LID_Search_Multiple_ID_Files')
    let LID_Search_Multiple_ID_Files = 0
endif

" Open the LID output window.  Set this variable to zero, to not open
" the LID output window by default.  You can open it manually by using
" the :cwindow command.
if !exists('LID_OpenQuickfixWindow')
    let LID_OpenQuickfixWindow = 1
endif

" Character to use to escape patterns and filenames before passing to lid.
if !exists('LID_Shell_Quote_Char')
    if has('win32') || has('win16') || has('win95')
        let LID_Shell_Quote_Char = ''
    else
        let LID_Shell_Quote_Char = "'"
    endif
endif

" This option controls whether the user is asked for the ID file every
" time the Lid command is run.  By default, the ID file specified by
" the LID_File variable is used.
if !exists('LID_Prompt_ID_Filename')
    let LID_Prompt_ID_Filename = 0
endif

" By default, when the lid output is displayed, the cursor will be
" automatically positioned at the first matching line.  You can set the
" LID_Jump_To_Match variable to 0 to prevent this.  In this case, only the
" output from LID will be displayed.
if !exists('LID_Jump_To_Match')
    let LID_Jump_To_Match = 1
endif

" Extract lines matching the supplied pattern from the supplied text
function! s:ExtractMatchingLines(txt, pattern)
    let filter_output = ''
    let t = a:txt

    let len = strlen(t)

    while t != ''
        let one_line = strpart(t, 0, stridx(t, "\n"))
        let t = strpart(t, stridx(t, "\n") + 1, len)

        if one_line =~# a:pattern
            let filter_output = filter_output . one_line . "\n"
        endif
    endwhile

    return filter_output
endfunction

" Remove lines matching the supplied pattern from the supplied text
function! s:RemoveMatchingLines(txt, pattern)
    let filter_output = ''
    let t = a:txt

    let len = strlen(t)

    while t != ''
        let one_line = strpart(t, 0, stridx(t, "\n"))
        let t = strpart(t, stridx(t, "\n") + 1, len)

        if one_line !~# a:pattern
            let filter_output = filter_output . one_line . "\n"
        endif
    endwhile

    return filter_output
endfunction

" Run lid using the supplied arguments
function! s:RunLid(...)
    let usage = 'Usage: Lid [[-p] [-v] [-?] [-h] [identifier]]'

    " If the user wanted to select the ID file everytime, Lid is run,
    " then ask for the location of the file.  Use the last ID file as
    " the default.  First time, use the global value as the default.
    if g:LID_Prompt_ID_Filename
        if !exists('s:LID_last_ID_file')
            let s:LID_last_ID_file = g:LID_File
        endif
        let id_file = input('Location of ID file: ', s:LID_last_ID_file)
        if id_file == ''
            return
        endif
        let s:LID_last_ID_file = id_file
    else
        let id_file = g:LID_File
    endif

    let skip_pat = ''
    let match_pat = ''

    if a:0 == 0 || a:1 == '-p' || a:1 == '-v'
        " Get the identifier from the user, if it is not already supplied
        let id = input('Lookup identifier: ', expand('<cword>'))
        if id == ''
            return
        endif
    endif

    " Process options
    if a:0 != 0
        if a:1 == '-p'
            let match_pat = input('Include only lines containing: ', '')
        elseif a:1 == '-v'
            let skip_pat = input('Exclude lines containing: ', '')
        elseif a:1 == '-?' || a:1 == '-h'
            echomsg usage
            return 1
        else
            let id = a:1
        endif
    endif

    echo "\n"

    let cmd_output = ''

    while id_file != ''
        if !g:LID_Search_Multiple_ID_Files && cmd_output != ''
            break
        endif

        let idx = stridx(id_file, ',')
        if idx == -1
            let one_file = id_file
            let id_file = ''
        else
            let one_file = strpart(id_file, 0, idx)
            let id_file = strpart(id_file, idx + 1)
        endif

        let cmd = g:LID_Cmd . ' -R grep -f ' . one_file . ' '
        let cmd = cmd . g:LID_Shell_Quote_Char . id . g:LID_Shell_Quote_Char

        let output = system(cmd)

        if v:shell_error && output != ''
            echohl WarningMsg | echomsg output | echohl None
            return
        endif

        let cmd_output = cmd_output . output
    endwhile

    if cmd_output == ''
        echohl WarningMsg | echomsg 'Error: Identifier ' . id . ' not found' | 
                   \ echohl None
        return
    endif

    " Extract lines containing the user specified pattern
    if match_pat != ''
        let cmd_output = s:ExtractMatchingLines(cmd_output, match_pat)

        " No more remaining lines
        if cmd_output == ''
            echohl WarningMsg
            echomsg 'Error: No matching lines containing "' . match_pat . '"'
            echohl None
            return
        endif
    endif

    " Remove lines containing the user specified pattern
    if skip_pat != ''
        let cmd_output = s:RemoveMatchingLines(cmd_output, skip_pat)

        " No more remaining lines
        if cmd_output == ''
            echohl WarningMsg
            echomsg 'Error: No matching lines containing "' . skip_pat . '"'
            echohl None
            return
        endif
    endif


    " Send the output to a temporary file to use with the :cfile command
    let tmpfile = tempname()

    exe 'redir! > ' . tmpfile
    silent echon cmd_output
    redir END

    " Set the 'errorformat' to parse the lid output.
    let old_efm = &efm
    set efm=%f:%l:%m

    execute 'silent! cfile ' . tmpfile

    let &efm = old_efm

    if !g:LID_Jump_To_Match
        execute "normal \<C-O>"
    endif

    " Open the lid output window
    if g:LID_OpenQuickfixWindow == 1
        " Open the quickfix window below the current window
        botright copen
    endif

    " Jump to the first match.  Otherwise, the cursor will be in the quickfix
    " window
    if g:LID_Jump_To_Match
        cc
    endif

    call delete(tmpfile)
endfunction

" Define the Lid command to run lid
command! -nargs=? -complete=tag Lid call s:RunLid(<f-args>)

