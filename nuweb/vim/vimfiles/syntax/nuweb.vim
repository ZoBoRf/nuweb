" Vim syntax file
" Language:	NUWEB
" Maintainer:	Patricio Toledo Pe~na <patoledo@ing.uchile.cl>
" Last Change:  lun ene 27 18:39:26 CLST 2003
" Obs:		WEB/CWEB files uses .w, so i decide to use .nw as
"		identificator

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" For starters, read the TeX syntax; TeX syntax items are allowed at the top
" level in the NUWEB syntax, e.g., in the preamble.  In general, a NUWEB source
" code can be seen as a normal TeX document with some other material
" interspersed in certain defined regions.
if version < 600
  source <sfile>:p:h/oldtex.vim
else
  runtime! syntax/oldtex.vim
  unlet b:current_syntax
endif

" Try to flag Scrap mismatches
syn region  nuwebMatcher    start="@{" skip="\(\\\|%\|#\)\+" end="@}\=" contains=nuwebError fold
syn match   nuwebError	"@}"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Fadeout TeX highlight between @{ and @}, like verbatim highlight
syn region  nuwebFade  start="@{" end="@}\|%stopzone" contains=nuwebFade,nuwebScrap,nuwebIndex,nuwebParameter,nuwebComment,nuwebBold fold

" High bold 
syn region  nuwebBold  start="@_" end="@_\|%stopzone" contains=nuwebFade,nuwebScrap,nuwebParameter,nuwebComment fold

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Highlight Scrap and Macros --> @o filename, 'til end of line 
syn region  nuwebFiles start="@\c\(o\|i\)\s\=" end="$"
syn region  nuwebMacro start="@\c\(d\|f\|m\|u\)\s\=" end="$"

" Highlight other Scrap
syn match   nuwebScrap	   "@\(<\|>\)\+"
syn match   nuwebScrap	   "@\([\|]\)\+"
syn match   nuwebScrap	   "@\((\|)\)\+"

syn match   nuwebParameter "@\d\+"

" Coments inside Scrap
syn match   nuwebComment   "@%.*$"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_tex_syntax_inits")
  if version < 508
    let did_tex_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

    HiLink  nuwebFade	    Statement
    HiLink  nuwebFiles	    Type
    HiLink  nuwebMacro	    Type
    HiLink  nuwebScrap	    Identifier
    HiLink  nuwebIndex	    Identifier
    HiLink  nuwebParameters Identifier
    HiLink  nuwebComment    Comment
    HiLink  nuwebError	    Error

  delcommand HiLink
endif

let b:current_syntax = "nuweb (Literate Programming)"
