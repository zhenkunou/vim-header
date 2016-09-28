" PROPERTIES AND FUNCTIONS FOR GENERAL PURPOSES
" ---------------------------------------------
" Set default global values
if !exists('g:header_field_filename')
    let g:header_field_filename = 1
endif
if !exists('g:header_field_author')
    let g:header_field_author = ''
endif
if !exists('g:header_field_author_email')
    let g:header_field_author_email = ''
endif
if !exists('g:header_field_timestamp')
    let g:header_field_timestamp = 1
endif
if !exists('g:header_field_timestamp_format')
    let g:header_field_timestamp_format = '%d.%m.%Y'
endif

" Path for licese files directory
let s:license_files_dir = expand('<sfile>:p:h:h').'/licensefiles/'

" Sets values respect to buffer's filetype
fun s:set_props()
    " Variables for General Purposes
    let b:filetype = &ft
    let b:is_filetype_available = 1 " To check if filetype comment syntax is defined

    " Default Values for Many Languages
    let b:first_line = '' " If file type has initial line
    let b:encoding = ''   " encoding
    let b:block_comment = 0 " If file type has block comment support
    let b:min_comment_begin = '' " If file type has a special char for minified versions
    let b:comment_char = '' " Comment char, or for block comment trailing char of body
    let b:auto_space_after_char = 1 " Put auto space after comment char, if line is not empty
    " Field placeholders according to doc comment syntax, if available
    let b:field_file = 'File:'
    let b:field_author = 'Author:'
    let b:field_date = 'Date:'

    " Setting Values for Languages
    if
        \ b:filetype == 'c' ||
        \ b:filetype == 'cpp' ||
        \ b:filetype == 'css' ||
        \ b:filetype == 'groovy' ||
        \ b:filetype == 'java' ||
        \ b:filetype == 'javascript' ||
        \ b:filetype == 'javascript.jsx' ||
        \ b:filetype == 'php' ||
        \ b:filetype == 'sass'

        let b:block_comment = 1
        let b:comment_char = ' *'
        let b:comment_begin = '/**'
        let b:comment_end = ' */'
    " ----------------------------------
    elseif b:filetype == 'haskell'
        let b:block_comment = 1
        let b:comment_char = ' -'
        let b:comment_begin = '{-'
        let b:comment_end = ' -}'
    " ----------------------------------
    elseif b:filetype == 'lua'
        let b:auto_space_after_char = 0
        let b:block_comment = 1
        let b:comment_begin = '--[[--'
        let b:comment_end = '--]]--'
    " ----------------------------------
    elseif b:filetype == 'perl'
        let b:first_line = '#!/usr/bin/env perl'
        let b:comment_char = '#'
    " ----------------------------------
    elseif b:filetype == 'python'
        let b:first_line = '#!/usr/bin/env python'
        let b:encoding = '# -*- coding: utf-8 -*-'
        let b:comment_char = '#'
    " ----------------------------------
    elseif b:filetype == 'sh'
        let b:first_line = '#!/bin/bash'
        let b:comment_char = '#'
    " ----------------------------------
    elseif b:filetype == 'vim'
        let b:comment_char = '"'
    " ----------------------------------
    else
        let b:is_filetype_available = 0
    endif

    " Individual settings for special cases
    if b:filetype == 'php'
        let b:first_line = '<?php'
    endif
    if b:filetype == 'css'
        let b:min_comment_begin = '/*!'
    endif
    if
        \ b:filetype == 'javascript' ||
        \ b:filetype == 'javascript.jsx'

        let b:field_file = '@file'
        let b:field_author = '@author'
        let b:field_date = '@date'
        let b:min_comment_begin = '/*!'
    endif

    " For license texts, if there is a empty line, avoid trailing white space
    let b:comment_char_wo_space = b:comment_char
    " If there is space after comment char, put it
    if b:auto_space_after_char
        let b:comment_char .= ' '
    endif
endfun

" HEADER GENERATORS
" -----------------
" Generate Header
fun s:add_header()
    let l:i = 0

    " If filetype has initial line
    if b:first_line != ''
        call append(l:i, b:first_line)
        let l:i += 1
    endif
    " if has encoding
    if b:encoding != ''
        call append(l:i, b:encoding)
        let l:i += 1
    endif
    " If filetype supports block comment, open comment
    if b:block_comment
        call append(l:i, b:comment_begin)
        let l:i += 1
    endif

    " Fill user's information
    if g:header_field_filename
        call append(l:i, b:comment_char . b:field_file . ' ' . expand('%s:t'))
        let l:i += 1
    endif
    if g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        call append(l:i, b:comment_char . b:field_author . ' ' . g:header_field_author . l:email)
        let l:i += 1
    endif
    if g:header_field_timestamp
        call append(l:i, b:comment_char . b:field_date . ' ' . strftime(g:header_field_timestamp_format))
        let l:i += 1
    endif

    " If filetype supports block comment, close comment
    if b:block_comment
        call append(l:i, b:comment_end)
    endif
endfun

" Generate Minified Header
fun s:add_min_header()
    let l:i = 0

    " If filetype has initial line
    if b:first_line != ''
        call append(l:i, b:first_line)
        let l:i += 1
    endif

    if b:encoding != ''
        call append(l:i, b:encoding)
        let l:i += 1
    endif

    " Set comment open char
    if b:block_comment
        if b:min_comment_begin == ''
            let l:header_line = b:comment_begin
        else
            let l:header_line = b:min_comment_begin
        endif
    else
        let l:header_line = b:comment_char
    endif

    " Fill user's information
    if g:header_field_filename
        let l:header_line .= ' ' . expand('%s:t')
    endif
    if g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        let l:header_line .= ' ' . b:field_author . ' "' . g:header_field_author . l:email . '"'
    endif
    if g:header_field_timestamp
        let l:header_line .= ' ' . b:field_date . ' ' . strftime(g:header_field_timestamp_format)
    endif

    " If filetype supports block comment, close comment
    if b:block_comment
        let l:header_line .= ' ' . b:comment_end
    endif

    " Add line to file
    call append(l:i, l:header_line)
endfun

" Generate License Header
fun s:add_license_header(license_name)
    " Path to license file
    let l:file_name = s:license_files_dir . a:license_name
    " If license file is not exists, inform user
    if !filereadable(l:file_name)
        echo 'There is no defined "' . a:license_name . '" license.'
        return
    endif

    " Add raw license, and count lines of it
    let l:license_line_count = -line('$')
    execute '0read ' . expand(l:file_name)
    let l:license_line_count += line('$')

    " Take raw license into comment
    let l:i = 1
    while l:i <= l:license_line_count
        let l:line = getline(l:i)
        " If there is a emty line, avoid putting trailing space
        if l:line == ''
            let l:line = b:comment_char_wo_space . l:line
        else
            let l:line = b:comment_char . l:line
        endif

        call setline(l:i,l:line)
        let l:i += 1
    endwhile

    " Surrounding license block with other infos
    let l:i = 0

    " If filetype has initial line
    if b:first_line != ''
        call append(0, b:first_line)
        let l:i += 1
    endif

    if b:encoding != ''
        call append(l:i, b:encoding)
        let l:i += 1
    endif

    " If filetype supports block comment, open comment
    if b:block_comment
        call append(l:i, b:comment_begin)
        let l:i += 1
    endif

    " Fill user's information
    if g:header_field_filename
        call append(l:i, b:comment_char . expand('%s:t'))
        let l:i += 1
    endif
    if g:header_field_author != ''
        if g:header_field_author_email != ''
            let l:email = ' <' . g:header_field_author_email . '>'
        else
            let l:email = ''
        endif
        call append(l:i, b:comment_char . 'Copyright (c) ' . strftime('%Y') . ' ' . g:header_field_author . l:email)
        call append(l:i+1, b:comment_char)
        let l:i += 2
    endif

    " If filetype supports block comment, close comment
    if b:block_comment
        call append(l:i+l:license_line_count, b:comment_end)
    endif
endfun

" MAIN FUNCTION
" -------------
" Main function selects header generator to add header
" type parameter options;
"   0: Normal Header
"   1: Minified Header
"   2: License Header (also uses license parameter)
fun header#add_header(type, license)
    " If block has been commented bc user may change filetype after opening buffer,
    " that's why props have to be set again for each call
    "if !exists('b:is_filetype_available')
        call s:set_props()
    "endif

    " If filetype is available, add header else inform user
    if b:is_filetype_available
        " Select header generator
        if a:type == 0
            call s:add_header()
        elseif a:type == 1
            call s:add_min_header()
        elseif a:type == 2
            call s:add_license_header(a:license)
        else
            echo 'There is no "' . a:type . '" type to add header.'
        endif
    else
        if b:filetype == ''
            let l:filetype = 'this'
        else
            let l:filetype = '"' . b:filetype . '"'
        endif
        echo 'No defined comment syntax for ' . l:filetype . ' filetype.'
    endif
endfun
