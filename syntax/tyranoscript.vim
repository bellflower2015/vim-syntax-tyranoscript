" Vim syntax file
" Language:     TyranoScript
" Maintainer:   Kikyou Akino <bellflower@web4u.jp>
" Homepage:     https://github.com/bellflower2015/vim-syntax-tyranoscript/tree/master
" Last Change:  2015-06-21
" Version:      1.0.0

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'tyranoscript'
elseif exists("b:current_syntax") && b:current_syntax == "javascript"
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syntax sync fromstart
syntax case match

" Tags
syntax region tyranoScriptTag               start=/\[/ end=/\]/ contains=tyranoScriptTagName,tyranoScriptAttribute
syntax region tyranoScriptTag               start=/@/  end=/$/  contains=tyranoScriptTagName,tyranoScriptAttribute

" Attribute
syntax match  tyranoScriptAttribute         +\<[^ \t="'\]]\++ contained nextgroup=tyranoScriptAttrEqual,tyranoScriptAttribute skipwhite
syntax match  tyranoScriptAttrEqual         "="               contained nextgroup=@tyranoScriptAttrValue

" Tag name
syntax match  tyranoScriptTagName           +\(\[\|@\)\@1<=[^ \t="'\]]\++ contained

" Attribute Value
syntax region  tyranoScriptAttrString        start=/"/ skip=/\\"/ end=/"/ contained
syntax region  tyranoScriptAttrString        start=/'/ skip=/\\'/ end=/'/ contained
syntax match   tyranoScriptAttrNumber        "\d\+" contained
syntax keyword tyranoScriptAttrBoolean       true false contained

syntax cluster tyranoScriptAttrValue         contains=tyranoScriptAttrString,tyranoScriptAttrNumber,tyranoScriptAttrBoolean

" Labels
syntax region tyranoScriptLabel             matchgroup=tyranoScriptLabelDescBar start=/^\*/ end=/$/ keepend contains=tyranoScriptLabelDescBar
syntax match  tyranoScriptLabelDescBar      "|"   contained

" Comment
syntax match  tyranoScriptLineComment       ";.*$"
syntax region tyranoScriptComment           start="/\*"  end="\*/" contains=@Spell

" Include JavaScript syntax.
if globpath(&rtp, 'syntax/javascript.vim') != ''
  syntax include @tyranoScriptJavaScriptTop syntax/javascript.vim
  syntax region  tyranoScriptJavaScript            start="^\[iscript\]"      end="^\[endscript\]" transparent keepend      contains=@tyranoScriptJavaScriptTop,tyranoScriptJavaScriptTag
  syntax region  tyranoScriptJavaScript            start="^@iscript$"        end="^@endscript$"   transparent keepend      contains=@tyranoScriptJavaScriptTop,tyranoScriptJavaScriptTag
  syntax region  tyranoScriptJavaScriptTag         start="^\[\(iscript\|endscript\)\@=" end="\]"  contained contains=tyranoScriptJavaScriptTagName
  syntax region  tyranoScriptJavaScriptTag         start="^@\(iscript\|endscript\)\@="  end="$"   contained contains=tyranoScriptJavaScriptTagName
  syntax keyword tyranoScriptJavaScriptTagName     iscript endscript contained
endif

" Folding
let g:use_tyranoscript_syntax_folding = get(g:, 'use_tyranoscript_syntax_folding', 1)
if g:use_tyranoscript_syntax_folding == 1
  syntax region tyranoScriptJavaScriptFold1      start="\[iscript\]" end="\[endscript\]" transparent fold keepend
  syntax region tyranoScriptJavaScriptFold2      start="^@iscript"   end="^@endscript"   transparent fold keepend
  syntax region tyranoScriptMacroFold1           start="\[macro"     end="\[endmacro\]"  transparent fold keepend
  syntax region tyranoScriptMacroFold2           start="^@macro"     end="^@endmacro"    transparent fold keepend
  set foldmethod=syntax
endif


" Define highlighting
if version >= 508 || !exists("did_tyranoscript_syn_inits")
  if version < 508
    let did_tyranoscript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink tyranoScriptLineComment        Comment
  HiLink tyranoScriptComment            Comment

  HiLink tyranoScriptTag                Special
  
  HiLink tyranoScriptAttribute          Type
  HiLink tyranoScriptAttrEqual          Statement

  HiLink tyranoScriptTagName            Statement

  HiLink tyranoScriptAttrString         String
  HiLink tyranoScriptAttrBoolean        Boolean
  HiLink tyranoScriptAttrNumber         Number
  
  HiLink tyranoScriptLabel              Label
  HiLink tyranoScriptLabelDescBar       Special

  HiLink tyranoScriptJavaScriptTag      tyranoScriptTag
  HiLink tyranoScriptJavaScriptTagName  tyranoScriptTagName

  delcommand HiLink
endif

let b:current_syntax = "tyranoscript"
if main_syntax == 'tyranoscript'
  unlet main_syntax
endif

let &cpo = s:cpo_save
unlet s:cpo_save
