" Sets values respect to buffer's filetype
fun s:setProps()
    " Variables for General Purposes
    let b:filetype = &ft
    let b:isFiletypeAvailable = 1 " To check if filetype comment syntax is defined

    " Default Values for Many Languages
    let b:firstLine = '' " If file type has initial line
    let b:blockComment = 0 " If file type has block comment support
    let b:minCommentBegin = '' " If file type has a special char for minified versions

    " Setting Values for Languages
    if b:filetype == 'c' ||
        \ b:filetype == 'cpp' ||
        \ b:filetype == 'css' ||
        \ b:filetype == 'java' ||
        \ b:filetype == 'javascript' ||
        \ b:filetype == 'php' " -----------------------------------------

        let b:blockComment = 1
        let b:commentChar = ' *'
        let b:commentBegin = '/*'
        let b:commentEnd = ' */'
    elseif b:filetype == 'perl' " -----------------------------------------
        let b:firstLine = '#!/usr/bin/env perl'
        let b:commentChar = '#'
    elseif b:filetype == 'python' " -----------------------------------------
        let b:firstLine = '#!/usr/bin/env python'
        let b:commentChar = '#'
    elseif b:filetype == 'sh' " -----------------------------------------
        let b:firstLine = '#!/bin/bash'
        let b:commentChar = '#'
    elseif b:filetype == 'vim' " -----------------------------------------
        let b:commentChar = '"'
    else " -----------------------------------------
        let b:isFiletypeAvailable = 0
    endif

    " Individual settings for special cases
    if b:filetype == 'php'
        let b:firstLine = '<?php'
    endif
    if b:filetype == 'css' ||
        \ b:filetype == 'javascript' ||
        \ b:filetype == 'php'

        let b:minCommentBegin = '/*!'
    endif
endfun

" Generate Header using Buffer Settings and Global Values
fun s:addHeader()
    let l:i = 0

    " If filetype has initial line
    if b:firstLine != ''
        call append(l:i,b:firstLine)
        let l:i += 1
    endif
    " If filetype supports block comment, open comment
    if b:blockComment
        call append(l:i,b:commentBegin)
        let l:i += 1
    endif

    " Fill user's information
    if g:HeaderFieldFilename
        call append(l:i,b:commentChar.' '.expand('%s:t'))
        let l:i += 1
    endif
    if g:HeaderFieldAuthor != ''
        if g:HeaderFieldAuthorEmail != ''
            let l:email = ' <'.g:HeaderFieldAuthorEmail.'>'
        else
            let l:email = ''
        endif
        call append(l:i,b:commentChar.' Author: '.g:HeaderFieldAuthor.l:email)
        let l:i += 1
    endif
    if g:HeaderFieldTimestamp
        call append(l:i,b:commentChar.' Date: '.strftime(g:HeaderFieldTimestampFormat))
        let l:i += 1
    endif

    " If filetype supports block comment, close comment
    if b:blockComment
        call append(l:i,b:commentEnd)
    endif
endfun

" Generate Minified Header using Buffer Settings and Global Values
fun s:addMinHeader()
    let l:i = 0

    " If filetype has initial line
    if b:firstLine != ''
        call append(l:i,b:firstLine)
        let l:i += 1
    endif

    " Set comment open char
    if b:blockComment
        if b:minCommentBegin == ''
            let l:headerLine = b:commentBegin
        else
            let l:headerLine = b:minCommentBegin
        endif
    else
        let l:headerLine = b:commentChar
    endif

    " Fill user's information
    if g:HeaderFieldFilename
        let l:headerLine .= ' '.expand('%s:t')
    endif
    if g:HeaderFieldAuthor != ''
        if g:HeaderFieldAuthorEmail != ''
            let l:email = ' <'.g:HeaderFieldAuthorEmail.'>'
        else
            let l:email = ''
        endif
        let l:headerLine .= ' Author: "'.g:HeaderFieldAuthor.l:email.'"'
    endif
    if g:HeaderFieldTimestamp
        let l:headerLine .= ' Date: '.strftime(g:HeaderFieldTimestampFormat)
    endif

    " If filetype supports block comment, close comment
    if b:blockComment
        let l:headerLine .= ' '.b:commentEnd
    endif

    " Add line to file
    call append(l:i,l:headerLine)
endfun

" Main function of header plugin
fun header#addHeader(minMod)
    " If buffer's filetype properties are not set, run it once
    if !exists('b:isFiletypeAvailable')
        call s:setProps()
    endif

    " Set default global values
    if !exists('g:HeaderFieldFilename')
        let g:HeaderFieldFilename = 1
    endif
    if !exists('g:HeaderFieldAuthor')
        let g:HeaderFieldAuthor = ''
    endif
    if !exists('g:HeaderFieldAuthorEmail')
        let g:HeaderFieldAuthorEmail = ''
    endif
    if !exists('g:HeaderFieldTimestamp')
        let g:HeaderFieldTimestamp = 1
    endif
    if !exists('g:HeaderFieldTimestampFormat')
        let g:HeaderFieldTimestampFormat = '%d.%m.%Y'
    endif

    " If filetype is available, add header else inform user
    if b:isFiletypeAvailable
        if a:minMod
            call s:addMinHeader()
        else
            call s:addHeader()
        endif
    else
        if b:filetype == ''
            let l:filetype = 'this'
        else
            let l:filetype = '"'.b:filetype.'"'
        endif
        echo 'No defined comment syntax for '.l:filetype.' filetype'
    endif
endfun
