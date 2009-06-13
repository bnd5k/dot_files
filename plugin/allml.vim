" allml.vim - useful XML/HTML mappings
" Author:       Tim Pope <vimNOSPAM@tpope.info>
" GetLatestVimScripts: 1896 1 :AutoInstall: allml.vim
" $Id: allml.vim,v 1.11 2007-07-16 17:46:25 tpope Exp $
"
" See allml.txt for help.  This can be accessed by doing
"
" :helptags ~/.vim/doc
" :help allml

" Licensed under the same terms as Vim itself.

" ============================================================================
 
if exists("g:loaded_allml") || &cp
    finish
endif
let g:loaded_allml = 1

if has("autocmd")
    augroup allml
        autocmd!
        autocmd FileType *html*,wml,xml,xslt,xsd,jsp    call s:Init()
        autocmd FileType php,asp*,cf,mason,eruby        call s:Init()
        if version >= 700
            autocmd InsertLeave * call s:Leave()
        endif
        autocmd CursorHold * if exists("b:loaded_allml") | call s:Leave() | endif
    augroup END
endif

inoremap <silent> <Plug>allmlHtmlComplete <C-R>=<SID>htmlEn()<CR><C-X><C-O><C-P><C-R>=<SID>htmlDis()<CR><C-N>

function! AllmlInit()
    " Public interface, for if you have your own filetypes to activate on
    call s:Init()
endfunction

function! s:Init()
    let b:loaded_allml = 1
    "inoremap <silent> <buffer> <SID>dtmenu  <C-R>=<SID>htmlEn()<CR><Lt>!DOCTYPE<C-X><C-O><C-R>=<SID>htmlDis()<CR><C-P>
    inoremap <silent> <buffer> <SID>xmlversion  <?xml version="1.0" encoding="<C-R>=toupper(<SID>charset())<CR>"?>
    inoremap      <buffer> <SID>htmltrans   <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    "inoremap      <buffer> <SID>htmlstrict  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
    inoremap      <buffer> <SID>xhtmltrans  <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    "inoremap      <buffer> <SID>xhtmlstrict <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    if s:subtype() == "xml"
        imap <script> <buffer> <SID>doctype <SID>xmlversion
    elseif exists("+omnifunc")
        inoremap <silent> <buffer> <SID>doctype  <C-R>=<SID>htmlEn()<CR><!DOCTYPE<C-X><C-O><C-P><C-R>=<SID>htmlDis()<CR><C-N><C-R>=<SID>doctypeSeek()<CR>
    elseif s:subtype() == "xhtml"
        imap <script> <buffer> <SID>doctype <SID>xhtmltrans
    else
        imap <script> <buffer> <SID>doctype <SID>htmltrans
    endif
    imap <script> <buffer> <C-X>! <SID>doctype

    "imap <buffer> <C-X>& <SID>doctype<C-O>ohtml<C-X><CR>head<C-X><CR><C-X>#<Esc>otitle<C-X><Space><C-R>=expand('%:t:r')<CR><Esc>jobody<C-X><CR><Esc>cc
    imap <silent> <buffer> <C-X># <meta http-equiv="Content-Type" content="text/html; charset=<C-R>=<SID>charset()<CR>"<C-R>=<SID>closetag()<CR>
    "map! <buffer> <SID>Thl html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"
    "map! <buffer> <C-X>h <Thl><CR></html><Esc>O
    inoremap <silent> <buffer> <SID>HtmlComplete <C-R>=<SID>htmlEn()<CR><C-X><C-O><C-P><C-R>=<SID>htmlDis()<CR><C-N>
    imap     <buffer> <C-X>H <SID>HtmlComplete
    inoremap <silent> <buffer> <C-X>$ <C-R>=<SID>javascriptIncludeTag()<CR>
    inoremap <silent> <buffer> <C-X>@ <C-R>=<SID>stylesheetTag()<CR>
    inoremap <silent> <buffer> <C-X><Space> <Esc>ciw<Lt><C-R>"<C-R>=<SID>tagextras()<CR>></<C-R>"><Esc>b2hi
    inoremap <silent> <buffer> <C-X><CR> <Esc>ciw<Lt><C-R>"<C-R>=<SID>tagextras()<CR>><CR></<C-R>"><Esc>O
    "noremap! <silent> <buffer> <C-X>, <C-R>=<SID>closetagback()<CR>
    if exists("&omnifunc")
        inoremap <silent> <buffer> <C-X>/ <Lt>/<C-R>=<SID>htmlEn()<CR><C-X><C-O><C-R>=<SID>htmlDis()<CR><C-F>
        if exists(":XMLns")
            XMLns xhtml10s
        endif
    else
        inoremap <silent> <buffer> <C-X>/ <Lt>/><Left>
    endif
    let g:surround_{char2nr("p")} = "<p>\n\t\r\n</p>"
    let g:surround_{char2nr("d")} = "<div\1div: \r^[^ ]\r &\1>\n\t\r\n</div>"
    imap <buffer> <C-X><C-_> <C-X>/
    imap <buffer> <SID>allmlOopen    <C-X><Lt><Space>
    imap <buffer> <SID>allmlOclose   <Space><C-X>><Left><Left>
    if &ft == "php"
        inoremap <buffer> <C-X><Lt> <?php
        inoremap <buffer> <C-X>>    ?>
        inoremap <buffer> <SID>allmlOopen    <?php<Space>print<Space>
        let b:surround_45 = "<?php \r ?>"
        let b:surround_61 = "<?php print \r ?>"
    elseif &ft == "htmltt" || &ft == "tt2html"
        inoremap <buffer> <C-X><Lt> [%
        inoremap <buffer> <C-X>>    %]
        let b:surround_45  = "[% \r %]"
        let b:surround_61  = "[% \r %]"
        if !exists("b:surround_101")
            let b:surround_101 = "[% \r %]\n[% END %]"
        endif
    elseif &ft =~ "django"
        "inoremap <buffer> <SID>allmlOopen    {{
        "inoremap <buffer> <SID>allmlOclose   }}<Left>
        inoremap <buffer> <C-X><Lt> {{
        inoremap <buffer> <C-X>>    }}
        let b:surround_45 = "{% \r %}"
        let b:surround_61 = "{{ \r }}"
    elseif &ft == "mason"
        inoremap <buffer> <SID>allmlOopen    <&<Space>
        inoremap <buffer> <SID>allmlOclose   <Space>&><Left><Left>
        inoremap <buffer> <C-X><Lt> <%
        inoremap <buffer> <C-X>>    %>
        let b:surround_45 = "<% \r %>"
        let b:surround_61 = "<& \r &>"
    elseif &ft == "cf"
        inoremap <buffer> <SID>allmlOopen    <cfoutput>
        inoremap <buffer> <SID>allmlOclose   </cfoutput><Left><C-Left><Left>
        inoremap <buffer> <C-X><Lt> <cf
        inoremap <buffer> <C-X>>    >
        let b:surround_45 = "<cf\r>"
        let b:surround_61 = "<cfoutput>\r</cfoutput>"
    else
        inoremap <buffer> <SID>allmlOopen    <%=<Space>
        inoremap <buffer> <C-X><Lt> <%
        inoremap <buffer> <C-X>>    %>
        let b:surround_45 = "<% \r %>"
        let b:surround_61 = "<%= \r %>"
    endif
    imap     <buffer> <C-X>= <SID>allmlOopen<SID>allmlOclose<Left>
    imap     <buffer> <C-X>+ <C-V><NL><Esc>I<SID>allmlOopen<Space><Esc>A<Space><SID>allmlOclose<Esc>F<NL>s
    " <%\n\n%>
    if &ft == "cf"
        inoremap <buffer> <C-X>] <cfscript><CR></cfscript><Esc>O
    elseif &ft == "mason"
        inoremap <buffer> <C-X>] <%perl><CR></%perl><Esc>O
    elseif &ft == "html" || &ft == "xhtml" || &ft == "xml"
        imap     <buffer> <C-X>] <script<Space>type="text/javascript"><CR></script><Esc>O
    else
        imap     <buffer> <C-X>] <C-X><Lt><CR><C-X>><Esc>O
    endif
    " <% %>
    if &ft == "eruby"
        inoremap  <buffer> <C-X>- <%<Space><Space>-%><Esc>3hi
        inoremap  <buffer> <C-X>_ <C-V><NL><Esc>I<%<Space><Esc>A<Space>-%><Esc>F<NL>s
        "let b:surround_45 = "<% \r -%>"
    elseif &ft == "cf"
        inoremap  <buffer> <C-X>- <cf><Left>
        inoremap  <buffer> <C-X>_ <cfset ><Left>
    else
        imap      <buffer> <C-X>- <C-X><Lt><Space><Space><C-X>><Esc>2hi
        imap      <buffer> <C-X>_ <C-V><NL><Esc>I<C-X><Lt><Space><Esc>A<Space><C-X>><Esc>F<NL>s
    endif
    " Comments
    if &ft =~ '^asp'
        imap     <buffer> <C-X>'     <C-X><Lt>'<Space><Space><C-X>><Esc>2hi
        imap     <buffer> <C-X>"     <C-V><NL><Esc>I<C-X><Lt>'<Space><Esc>A<Space><C-X>><Esc>F<NL>s
        let b:surround_35 = maparg("<C-X><Lt>","i")."' \r ".maparg("<C-X>>","i")
    elseif &ft == "jsp"
        inoremap <buffer> <C-X>'     <Lt>%--<Space><Space>--%><Esc>4hi
        inoremap <buffer> <C-X>"     <C-V><NL><Esc>I<%--<Space><Esc>A<Space>--%><Esc>F<NL>s
        let b:surround_35 = "<%-- \r --%>"
    elseif &ft == "cf"
        inoremap <buffer> <C-X>'     <Lt>!---<Space><Space>---><Esc>4hi
        inoremap <buffer> <C-X>"     <C-V><NL><Esc>I<!---<Space><Esc>A<Space>---><Esc>F<NL>s
        setlocal commentstring=<!---%s--->
        let b:surround_35 = "<!--- \r --->"
    elseif &ft == "html" || &ft == "xml" || &ft == "xhtml"
        inoremap <buffer> <C-X>'     <Lt>!--<Space><Space>--><Esc>3hi
        inoremap <buffer> <C-X>"     <C-V><NL><Esc>I<!--<Space><Esc>A<Space>--><Esc>F<NL>s
        let b:surround_35 = "<!-- \r -->"
    elseif &ft == "django"
        inoremap <buffer> <C-X>'     {#<Space><Space>#}<Esc>2hi
        inoremap <buffer> <C-X>"     <C-V><NL><Esc>I<C-X>{#<Space><Esc>A<Space>#}<Esc>F<NL>s
        let b:surround_35 = "{# \r #}"
    else
        imap     <buffer> <C-X>'     <C-X><Lt>#<Space><Space><C-X>><Esc>2hi
        imap     <buffer> <C-X>"     <C-V><NL><Esc>I<C-X><Lt>#<Space><Esc>A<Space><C-X>><Esc>F<NL>s
        let b:surround_35 = maparg("<C-X><Lt>","i")."# \r ".maparg("<C-X>>","i")
    endif
    map  <buffer> <LocalLeader>eu  <Plug>allmlUrlEncode
    map  <buffer> <LocalLeader>du  <Plug>allmlUrlDecode
    map  <buffer> <LocalLeader>ex  <Plug>allmlXmlEncode
    map  <buffer> <LocalLeader>dx  <Plug>allmlXmlDecode
    nmap <buffer> <LocalLeader>euu <Plug>allmlLineUrlEncode
    nmap <buffer> <LocalLeader>duu <Plug>allmlLineUrlDecode
    nmap <buffer> <LocalLeader>exx <Plug>allmlLineXmlEncode
    nmap <buffer> <LocalLeader>dxx <Plug>allmlLineXmlDecode
    imap <buffer> <C-X>%           <Plug>allmlUrlEncode
    imap <buffer> <C-X>&           <Plug>allmlXmlEncode
    imap <buffer> <C-V>%           <Plug>allmlUrlV
    imap <buffer> <C-V>&           <Plug>allmlXmlV
    " Are these really worth it?
    "nmap <script><buffer> <LocalLeader>iu  i<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>ix  i<SID>allmlXmlEncode
    "nmap <script><buffer> <LocalLeader>Iu  I<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>Ix  I<SID>allmlXmlEncode
    "nmap <script><buffer> <LocalLeader>au  a<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>ax  a<SID>allmlXmlEncode
    "nmap <script><buffer> <LocalLeader>Au  A<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>Ax  A<SID>allmlXmlEncode
    "nmap <script><buffer> <LocalLeader>ou  o<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>ox  o<SID>allmlXmlEncode
    "nmap <script><buffer> <LocalLeader>Ou  O<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>Ox  O<SID>allmlXmlEncode
    "nmap <script><buffer> <LocalLeader>su  s<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>sx  s<SID>allmlXmlEncode
    "nmap <script><buffer> <LocalLeader>Su  S<SID>allmlUrlEncode
    "nmap <script><buffer> <LocalLeader>Sx  S<SID>allmlXmlEncode
    "if has("spell")
        "setlocal spell
    "endif
    if !exists("b:did_indent")
        if s:subtype() == "xml"
            runtime! indent/xml.vim
        else
            runtime! indent/html.vim
        endif
    endif
    " Pet peeve.  Do people still not close their <p> and <li> tags?
    if exists("g:html_indent_tags") && g:html_indent_tags !~ '\\|p\>'
        let g:html_indent_tags = g:html_indent_tags.'\|p\|li'
    endif
    set indentkeys+=!^F
    let b:surround_indent = 1
    silent doautocmd User allml
endfunction

function! s:Leave()
    call s:disableescape()
endfunction

function! s:length(str)
    return strlen(substitute(a:str,'.','.','g'))
endfunction

function! s:repeat(str,cnt)
    let cnt = a:cnt
    let str = ""
    while cnt > 0
        let str = str . a:str
        let cnt = cnt - 1
    endwhile
    return str
endfunction

function! s:doctypeSeek()
    if !exists("b:allml_doctype_index")
        if &ft == 'xhtml' || &ft == 'eruby'
            let b:allml_doctype_index = 10
        elseif &ft != 'xml'
            let b:allml_doctype_index = 7
        endif
    endif
    let index = b:allml_doctype_index - 1
    return (index < 0 ? s:repeat("\<C-P>",-index) : s:repeat("\<C-N>",index))
endfunction

function! s:stylesheetTag()
    if !exists("b:allml_stylesheet_link_tag")
        if &ft == "eruby" && expand('%:p') =~ '\<app[\\/]views\>'
            " This will ultimately be factored into rails.vim
            let b:allml_stylesheet_link_tag = "<%= stylesheet_link_tag '\r' %>"
        else
            let b:allml_stylesheet_link_tag = "<link rel=\"stylesheet\" type=\"text/css\" href=\"/stylesheets/\r.css\" />"
        endif
    endif
    return s:insertTag(b:allml_stylesheet_link_tag)
endfunction

function! s:javascriptIncludeTag()
    if !exists("b:allml_javascript_include_tag")
        if &ft == "eruby" && expand('%:p') =~ '\<app[\\/]views\>'
            " This will ultimately be factored into rails.vim
             let b:allml_javascript_include_tag = "<%= jaaaavascript_include_tag :\rdefaults\r %>"
         else
             let b:allml_javascript_include_tag = "<script type=\"text/javascript\" src=\"/javascripts/\r.js\"></script>"
        endif
    endif
    return s:insertTag(b:allml_javascript_include_tag)
endfunction

function! s:insertTag(tag)
    let tag = a:tag
    if s:subtype() == "html"
        let tag = substitute(a:tag,'\s*/>','>','g')
    endif
    let before = matchstr(tag,'^.\{-\}\ze\r')
    let after  = matchstr(tag,'\r\zs\%(.*\r\)\@!.\{-\}$')
    " middle isn't currently used
    let middle = matchstr(tag,'\r\zs.\{-\}\ze\r')
    return before.after.s:repeat("\<Left>",s:length(after))
endfunction


function! s:htmlEn()
    let b:allml_omni = &l:omnifunc
    let b:allml_isk = &l:isk
    " : is for namespaced xml attributes
    setlocal omnifunc=htmlcomplete#CompleteTags isk+=:
    return ""
endfunction

function! s:htmlDis()
    if exists("b:allml_omni")
        let &l:omnifunc = b:allml_omni
        unlet b:allml_omni
    endif
    if exists("b:allml_isk")
        let &l:isk = b:allml_isk
        unlet b:allml_isk
    endif
    return ""
endfunction

function! s:subtype()
    let top = getline(1)."\n".getline(2)
    if (top =~ '<?xml\>' && &ft !~? 'html') || &ft =~? '^\%(xml\|xsd\|xslt\)$'
        return "xml"
    elseif top =~? '\<xhtml\>'
        return 'xhtml'
    elseif top =~ '[^<]\<html\>'
        return "html"
    elseif &ft == "xhtml" || &ft == "eruby"
        return "xhtml"
    elseif exists("b:loaded_allml")
        return "html"
    else
        return ""
    endif
endfunction

function! s:closetagback()
    if s:subtype() == "html"
        return ">\<Left>"
    else
        return " />\<Left>\<Left>\<Left>"
    endif
endfunction

function! s:closetag()
    if s:subtype() == "html"
        return ">"
    else
        return " />"
    endif
endfunction

function! s:charset()
    let enc = &fileencoding
    if enc == ""
        let enc = &encoding
    endif
    if enc == "latin1"
        return "ISO-8859-1"
    elseif enc == ""
        return "US-ASCII"
    else
        return enc
    endif
endfunction

function! s:tagextras()
    if s:subtype() == "xml"
        return ""
    elseif @" == 'html' && s:subtype() == 'xhtml'
        let lang = "en"
        if exists("$LANG") && $LANG =~ '^..'
            let lang = strpart($LANG,0,2)
        endif
        return ' xmlns="http://www.w3.org/1999/xhtml" lang="'.lang.'" xml:lang="'.lang.'"'
    elseif @" == 'style'
        return ' type="text/css"'
    elseif @" == 'script'
        return ' type="text/javascript"'
    elseif @" == 'table'
        return ' cellspacing="0"'
    else
        return ""
    endif
endfunction

function! s:UrlEncode(str)
    return substitute(a:str,'[^A-Za-z0-9_.~-]','\="%".printf("%02X",char2nr(submatch(0)))','g')
endfunction

function! s:UrlDecode(str)
    let str = substitute(substitute(substitute(a:str,'%0[Aa]\n$','%0A',''),'%0[Aa]','\n','g'),'+',' ','g')
    return substitute(str,'%\(\x\x\)','\=nr2char("0x".submatch(1))','g')
endfunction

let s:entities = "\u00a0nbsp\n\u00a9copy\n\u00ablaquo\n\u00aereg\n\u00b5micro\n\u00b6para\n\u00bbraquo\n\u2018lsquo\n\u2019rsquo\n\u201cldquo\n\u201drdquo\n\u2026hellip\n"

function! s:XmlEncode(str)
    let str = a:str
    let str = substitute(str,'&','\&amp;','g')
    let str = substitute(str,'<','\&lt;','g')
    let str = substitute(str,'>','\&gt;','g')
    let str = substitute(str,'"','\&quot;','g')
    if s:subtype() == 'xml'
        let str = substitute(str,"'",'\&apos;','g')
    elseif s:subtype() =~ 'html'
        let changes = s:entities
        while changes != ""
            let orig = matchstr(changes,'.')
            let repl = matchstr(changes,'^.\zs.\{-\}\ze\%(\n\|$\)')
            let changes = substitute(changes,'^.\{-\}\%(\n\|$\)','','')
            let str = substitute(str,'\M'.orig,'\&'.repl.';','g')
        endwhile
    endif
    return str
endfunction

function! s:XmlDecode(str)
    let str = substitute(a:str,'&#\%(0*38\|x0*26\);','&amp;','g')
    let changes = s:entities
    while changes != ""
        let orig = matchstr(changes,'.')
        let repl = matchstr(changes,'^.\zs.\{-\}\ze\%(\n\|$\)')
        let changes = substitute(changes,'^.\{-\}\%(\n\|$\)','','')
        let str = substitute(str,'&'.repl.';',orig == '&' ? '\&' : orig,'g')
    endwhile
    let str = substitute(str,'&#\(\d\+\);','\=nr2char(submatch(1))','g')
    let str = substitute(str,'&#\(x\x\+\);','\=nr2char("0".submatch(1))','g')
    let str = substitute(str,'&apos;',"'",'g')
    let str = substitute(str,'&quot;','"','g')
    let str = substitute(str,'&gt;','>','g')
    let str = substitute(str,'&lt;','<','g')
    return substitute(str,'&amp;','\&','g')
endfunction

function! s:opfuncUrlEncode(type)
    return s:opfunc("UrlEncode",a:type)
endfunction

function! s:opfuncUrlDecode(type)
    return s:opfunc("UrlDecode",a:type)
endfunction

function! s:opfuncXmlEncode(type)
    return s:opfunc("XmlEncode",a:type)
endfunction

function! s:opfuncXmlDecode(type)
    return s:opfunc("XmlDecode",a:type)
endfunction

function! s:opfunc(algorithm,type)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@
    if a:type =~ '^\d\+$'
        silent exe 'norm! ^v'.a:type.'$hy'
    elseif a:type =~ '^.$'
        silent exe "normal! `<" . a:type . "`>y"
    elseif a:type == 'line'
        silent exe "normal! '[V']y"
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]y"
    else
        silent exe "normal! `[v`]y"
    endif
    let @@ = s:{a:algorithm}(@@)
    norm! gvp
    let &selection = sel_save
    let @@ = reg_save
endfunction

inoremap <silent> <SID>urlequal <C-R>=<SID>getinput()=~?'\%([?&]\<Bar>&amp;\)[%a-z0-9._~-]*$'?'=':'%3D'<CR>
inoremap <silent> <SID>urlspace <C-R>=<SID>getinput()=~?'\%([?&]\<Bar>&amp;\)[%a-z0-9._~+-]*=[%a-z0-9._~+-]*$'?'+':'%20'<CR>

function! s:urltab(htmlesc)
    let line = s:getinput()
    let g:line = line
    if line =~ '[^ <>"'."'".']\@<!\w\+$'
        return ":"
    elseif line =~ '[^ <>"'."'".']\@<!\w\+:/\=/\=[%a-z0-9._~+-]*$'
        return "/"
    elseif line =~? '\%([?&]\|&amp;\)[%a-z0-9._~+-]*$'
        return "="
    elseif line =~? '\%([?&]\|&amp;\)[%a-z0-9._~+-]*=[%a-z0-9._~+-]*$'
        if a:htmlesc || synIDattr(synID(line('.'),col('.')-1,1),"name") =~ 'mlString$'
            return "&amp;"
        else
            return "&"
        endif
    elseif line =~ '/$\|\.\w\+$'
        return "?"
    else
        return "/"
    endif
endfunction

function! s:toggleurlescape()
    let htmllayer = 0
    if exists("b:allml_escape_mode")
        if b:allml_escape_mode == "url"
            call s:disableescape()
            return ""
        elseif b:allml_escape_mode == "xml"
            let htmllayer = 1
        endif
        call s:disableescape()
    endif
    let b:allml_escape_mode = "url"
    imap     <buffer> <BS> <Plug>allmlBSUrl
    inoremap <buffer> <CR> %0A
    imap <script> <buffer> <Space> <SID>urlspace
    "imap <script> <buffer> =       <SID>urlequal
    inoremap <buffer> <Tab> &
    inoremap <buffer> <Bar> %7C
    if htmllayer
        inoremap <silent> <buffer> <Tab> <C-R>=<SID>urltab(1)<CR>
    else
        inoremap <silent> <buffer> <Tab> <C-R>=<SID>urltab(0)<CR>
    endif
    let i = 33
    while i < 127
        " RFC3986: reserved = :/?#[]@ !$&'()*+,;=
        if nr2char(i) =~# '[|=A-Za-z0-9_.~-]'
        else
            call s:urlmap(nr2char(i))
        endif
        let i = i + 1
    endwhile
    return ""
endfunction

function! s:urlencode(char)
    let i = 0
    let repl = ""
    while i < strlen(a:char)
        let repl  = repl . printf("%%%02X",char2nr(strpart(a:char,i,1)))
        let i = i + 1
    endwhile
    return repl
endfunction

function! s:urlmap(char)
    let repl = s:urlencode(a:char)
    exe "inoremap <buffer> ".a:char." ".repl
endfunction

function! s:urlv()
    return s:urlencode(nr2char(getchar()))
endfunction

function! s:togglexmlescape()
    if exists("b:allml_escape_mode")
        if b:allml_escape_mode == "xml"
            call s:disableescape()
            return ""
        endif
        call s:disableescape()
    endif
    let b:allml_escape_mode = "xml"
    imap <buffer> <BS> <Plug>allmlBSXml
    inoremap <buffer> <Lt> &lt;
    inoremap <buffer> >    &gt;
    inoremap <buffer> &    &amp;
    inoremap <buffer> "    &quot;
    return ""
endfunction

function! s:disableescape()
    if exists("b:allml_escape_mode")
        if b:allml_escape_mode == "xml"
            silent! iunmap <buffer> <BS>
            silent! iunmap <buffer> <Lt>
            silent! iunmap <buffer> >
            silent! iunmap <buffer> &
            silent! iunmap <buffer> "
        elseif b:allml_escape_mode == "url"
            silent! iunmap <buffer> <BS>
            silent! iunmap <buffer> <Tab>
            silent! iunmap <buffer> <CR>
            silent! iunmap <buffer> <Space>
            silent! iunmap <buffer> <Bar>
            let i = 33
            while i < 127
                if nr2char(i) =~# '[|A-Za-z0-9_.~-]'
                else
                    exe "silent! iunmap <buffer> ".nr2char(i)
                endif
                let i = i + 1
            endwhile
        endif
        unlet b:allml_escape_mode
    endif
endfunction

function! s:getinput()
    return strpart(getline('.'),0,col('.')-1)
endfunction

function! s:bspattern(pattern)
    let start = s:getinput()
    let match = matchstr(start,'\%('.a:pattern.'\)$')
    if match == ""
      return "\<BS>"
    else
      return s:repeat("\<BS>",strlen(match))
    endif
endfunction

nnoremap <silent> <Plug>allmlUrlEncode :<C-U>set opfunc=<SID>opfuncUrlEncode<CR>g@
vnoremap <silent> <Plug>allmlUrlEncode :<C-U>call <SID>opfuncUrlEncode(visualmode())<CR>
nnoremap <silent> <Plug>allmlLineUrlEncode :<C-U>call <SID>opfuncUrlEncode(v:count1)<CR>
nnoremap <silent> <Plug>allmlUrlDecode :<C-U>set opfunc=<SID>opfuncUrlDecode<CR>g@
vnoremap <silent> <Plug>allmlUrlDecode :<C-U>call <SID>opfuncUrlDecode(visualmode())<CR>
nnoremap <silent> <Plug>allmlLineUrlDecode :<C-U>call <SID>opfuncUrlDecode(v:count1)<CR>
nnoremap <silent> <Plug>allmlXmlEncode :<C-U>set opfunc=<SID>opfuncXmlEncode<CR>g@
vnoremap <silent> <Plug>allmlXmlEncode :<C-U>call <SID>opfuncXmlEncode(visualmode())<CR>
nnoremap <silent> <Plug>allmlLineXmlEncode :<C-U>call <SID>opfuncXmlEncode(v:count1)<CR>
nnoremap <silent> <Plug>allmlXmlDecode :<C-U>set opfunc=<SID>opfuncXmlDecode<CR>g@
vnoremap <silent> <Plug>allmlXmlDecode :<C-U>call <SID>opfuncXmlDecode(visualmode())<CR>
nnoremap <silent> <Plug>allmlLineXmlDecode :<C-U>call <SID>opfuncXmlDecode(v:count1)<CR>

inoremap <silent> <Plug>allmlBSUrl     <C-R>=<SID>bspattern('%\x\x\=\<Bar>&amp;')<CR>
inoremap <silent> <Plug>allmlBSXml     <C-R>=<SID>bspattern('&#\=\w*;\<Bar><[^><]*>\=')<CR>
inoremap <silent>  <SID>allmlUrlEncode <C-R>=<SID>toggleurlescape()<CR>
inoremap <silent>  <SID>allmlXmlEncode <C-R>=<SID>togglexmlescape()<CR>
inoremap <silent> <Plug>allmlUrlEncode <C-R>=<SID>toggleurlescape()<CR>
inoremap <silent> <Plug>allmlXmlEncode <C-R>=<SID>togglexmlescape()<CR>
inoremap <silent> <Plug>allmlUrlV      <C-R>=<SID>urlv()<CR>
inoremap <silent> <Plug>allmlXmlV      <C-R>="&#".getchar().";"<CR>

if exists("g:allml_global_maps")
    imap     <C-X>H      <Plug>allmlHtmlComplete
    imap     <C-X>/    </<Plug>allmlHtmlComplete
    imap     <C-X>%      <Plug>allmlUrlEncode
    imap     <C-X>&      <Plug>allmlXmlEncode
    imap     <C-V>%      <Plug>allmlUrlV
    imap     <C-V>&      <Plug>allmlXmlV
    map      <Leader>eu  <Plug>allmlUrlEncode
    map      <Leader>du  <Plug>allmlUrlDecode
    map      <Leader>ex  <Plug>allmlXmlEncode
    map      <Leader>dx  <Plug>allmlXmlDecode
    nmap     <Leader>euu <Plug>allmlLineUrlEncode
    nmap     <Leader>duu <Plug>allmlLineUrlDecode
    nmap     <Leader>exx <Plug>allmlLineXmlEncode
    nmap     <Leader>dxx <Plug>allmlLineXmlDecode
endif
