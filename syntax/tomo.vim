" Language:    Tomo
" Maintainer:  Bruce Hill <bruce@bruce-hill.com>
" License:     WTFPL

" Bail if our syntax is already loaded.
if exists('b:current_syntax') && b:current_syntax == 'tomo'
  finish
endif

syn match TomoErrorWord /\i*/ contained
hi def link TomoErrorWord Error

syn match TomoVar /[a-zA-Z_][a-zA-Z_0-9]*/

syn match TomoNumber /0x[0-9a-fA-F_]\+%\?\|[0-9][0-9_]*\(\.\([0-9][0-9_]*\|\.\@!\)\)\?\(e[0-9_]\+\)\?%\?\|\.\@<!\.[0-9][0-9_]*\(e[0-9_]\+\)\?%\?/
hi def link TomoNumber Number

syn match TomoChar /`./
hi def link TomoChar String

syn region TomoString start=/".\@=/ end=/"\|$/ contains=TomoStringInterp,TomoEscape
syn region TomoString start=/'.\@=/ end=/'\|$/ contains=TomoStringInterp,TomoEscape
syn region TomoString start=/`.\@=/ end=/`\|$/ contains=TomoStringInterpAt,TomoEscape
syn region TomoString start=/".\@!\%(^\z(\s*\).*\)\@<=/ end=/^\z1"\|^\%(\z1\s\)\@!\s*\S\@=/ contains=TomoStringInterp,TomoEscape
syn region TomoString start=/'.\@!\%(^\z(\s*\).*\)\@<=/hs=e+1 end=/^\z1'\|^\%(\z1\s\)\@!\s*\S\@=/he=s-1 contains=TomoStringInterp,TomoEscape
syn region TomoString start=/`.\@!\%(^\z(\s*\).*\)\@<=/hs=e+1 end=/^\z1`\|^\%(\z1\s\)\@!\s*\S\@=/he=s-1 contains=TomoStringInterpAt,TomoEscape
hi def link TomoString String

syn region TomoPath start=;(\(\~/\|\./\|\.\./\|/\); skip=/\\.\|([^)]*)/ end=;$\|); contains=TomoEscape
hi def link TomoPath String

"syn region TomoDSLString start=/\z(["'`|/;([{<]\).\@=/hs=e end=/\z1/ contains=TomoStringInterp,TomoEscape contained
"syn region TomoDSLString start=/\z(["'`|/;([{<]\).\@!\%(^\z(\s*\).*\)\@<=/hs=e end=/^\z2\z1/he=e contains=TomoStringInterp,TomoEscape contained
"syn region TomoDSLString start=/\[/hs=e+1 end=/]/he=s-1 contains=TomoStringInterp,TomoEscape contained
"syn region TomoDSLString start=/{/hs=e+1 end=/}/he=s-1 contains=TomoStringInterp,TomoEscape contained
"syn region TomoDSLString start=/</hs=e+1 end=/>/he=s-1 contains=TomoStringInterp,TomoEscape contained
"syn region TomoDSLString start=/(/hs=e+1 end=/)/he=s-1 contains=TomoStringInterp,TomoEscape contained
"hi def link TomoDSLString String

syn match TomoArray /\[/ nextgroup=TomoTypeAnnotation
syn match TomoTable /{/ nextgroup=TomoTypeAnnotation

syn match TomoDocTest /^\s*>>>/
syn region TomoDocTest start=/^\s*===/ end=/$/
hi TomoDocTest ctermfg=gray

syn match TomoDocError /!!!.*/
hi TomoDocError ctermfg=red cterm=italic

syn match TomoDSL /\$\d\@!\w*/ nextgroup=TomoString
hi def link TomoDSL String
hi TomoDSL ctermfg=white cterm=bold

"syn match TomoCustomStringInterp /[~!@#$%^&*+=\?]\?/ contained nextgroup=TomoDSLString
"hi TomoCustomStringInterp ctermfg=gray

syn match TomoStringDollar /\$/ contained
hi TomoStringDollar ctermfg=LightBlue

syn match TomoStringAt /@/ contained
hi TomoStringAt ctermfg=LightBlue

syn match TomoStringInterpWord /[a-zA-Z_][a-zA-Z_0-9]*/ contained
hi TomoStringInterpWord ctermfg=LightBlue

syn match TomoStringInterp /\$/ contained nextgroup=TomoStringDollar,TomoStringInterpWord,TomoParenGroup,@TomoAll
hi TomoStringInterp ctermfg=LightBlue

syn match TomoStringInterpAt /@/ contained nextgroup=TomoStringAt,TomoStringInterpWord,TomoParenGroup,@TomoAll
hi TomoStringInterpAt ctermfg=LightBlue

syn match TomoEscape /\\\([abenrtvN]\|x\x\x\|\d\{3}\|{[^}]*}\|\[[^]]*\]\)\|\\./
hi TomoEscape ctermfg=LightBlue

syn keyword TomoExtern extern
hi def link TomoExtern Statement

syn keyword TomoConditional if unless else when then defer holding
hi def link TomoConditional Conditional

syn keyword TomoLoop for while do until repeat
hi def link TomoLoop Repeat

syn keyword TomoFail fail
hi def link TomoFail Exception

syn keyword TomoStatement stop skip break continue fail pass return del struct lang extend assert
hi def link TomoStatement Statement

syn keyword TomoNone none
hi TomoNone ctermfg=red

syn keyword TomoSerializing deserialize
hi TomoSerializing ctermfg=blue cterm=bold

syn region TomoUse matchgroup=Keyword start=/\<use\>/ matchgroup=TomoDelim end=/$\|;/ 
hi def link TomoUse String

syn match TomoArgDefault /=/ nextgroup=@TomoAll skipwhite contained
hi def link TomoArgDefault Operator
syn match TomoReturnSignature /->/ nextgroup=TomoType skipwhite contained
hi def link TomoReturnSignature Operator
syn region TomoFnArgSignature start=/(/ end=/)/ contains=TomoVar,TomoDelim,TomoTypeAnnotation,TomoArgDefault,TomoComment nextgroup=TomoReturnSignature skipwhite contained
syn match TomoFnName /\<[a-zA-Z_][a-zA-Z_0-9]*\>/ nextgroup=TomoFnArgSignature skipwhite contained
hi def link TomoFnName Function
syn keyword TomoFuncDef func nextgroup=TomoFnName skipwhite
hi def link TomoFuncDef Keyword
syn keyword TomoConvertDef convert nextgroup=TomoFnArgSignature skipwhite
hi def link TomoConvertDef Keyword

syn match TomoTagEquals /=/ skipwhite nextgroup=TomoErrorWord,TomoNumber contained
hi def link TomoTagEquals Operator
syn match TomoTagType /(/ nextgroup=TomoType contained
syn match TomoTag /[a-zA-Z_]\i*/ nextgroup=TomoTagType contained
hi TomoTag cterm=bold

syn keyword TomoEnum enum skipwhite nextgroup=TomoTaggedUnion
hi def link TomoEnum Keyword
syn region TomoTaggedUnion start=/:=/ skip=/|/ end=/$/ contains=TomoTag,TomoTagEquals contained

" syn region TomoFnDecl start=/\<def\>/ end=/(\@=\|$/ contains=TomoFnName,TomoKeyword

syn keyword TomoBoolean yes no
hi def link TomoBoolean Boolean

syn match TomoStructName /\w\+\( *{\)\@=/
hi TomoStructName cterm=bold

syn keyword TomoOperator in and or xor is not mod mod1 _min_ _max_ _mix_ mutexed
syn match TomoOperator ;\([a-zA-Z0-9_)] *\)\@<=/;
syn match TomoOperator ;[+*^<>=-]=\?;
syn match TomoOperator /[:!]\?=/
syn match TomoOperator /[#?:]/
hi def link TomoOperator Operator

syn match TomoDelim /,/
hi def link TomoDelim Delimiter

syn match TomoTableValueType /:/ nextgroup=TomoType contained
hi def link TomoTableValueType Type
syn match TomoTypeDelim /,/ contained
hi def link TomoTypeDelim Type
syn match TomoAssoc /=/ contained
hi def link TomoAssoc Type
syn region TomoType start=/\[/ end=/\]\|\():\)\@=\|$/ contains=TomoType contained nextgroup=TomoTableValueType
syn region TomoType start=/{/ end=/}\|\():\)\@=\|$/ contains=TomoType,TomoAssoc contained nextgroup=TomoTableValueType
syn region TomoType start=/func(/ end=/) *\(->\)\?/ contains=TomoType,TomoTypeDelim nextgroup=TomoType contained
syn match TomoType /[a-zA-Z_]\i*/ contained nextgroup=TomoTableValueType
syn match TomoType /\$[a-zA-Z_0-9]\+/ contained nextgroup=TomoTableValueType
syn match TomoType /[@?&]\+/ contained nextgroup=TomoType
hi def link TomoType Type

syn match TomoTypeAnnotation /:=\@!/ nextgroup=TomoType contained
hi def link TomoTypeAnnotation Operator

syn region TomoComment start=;#; end=/$/
hi def link TomoComment Comment

syn region TomoSay start=;!!; end=/$/ contains=TomoEscape,TomoStringInterp
hi TomoSay ctermfg=white cterm=bold

syn region TomoInlineCParens start=/(/ end=/)/ contains=TomoInlineCParens contained
hi def link TomoInlineCParens String

syn region TomoInlineCBraces start=/{/ end=/}/ contains=TomoInlineCBraces contained
hi def link TomoInlineCBraces String

syn match TomoInlineC ;\<C_code\> *; nextgroup=TomoInlineCBraces,TomoInlineCParens
hi def link TomoInlineC Keyword

syn region TomoParenGroup start=/(/ end=/)/ contains=@TomoAll,TomoParenGroup contained

syn match TomoLinkerDirective ;^\s*!link.*$;
hi TomoLinkerDirective ctermbg=blue ctermfg=black

syn cluster TomoAll contains=TomoVar,TomoComment,TomoChar,TomoString,TomoDSL,TomoPath,TomoKeyword,TomoOperator,
      \TomoConditional,TomoLoop,TomoFail,TomoNone,TomoSerializing,TomoStatement,TomoStructure,TomoTypedef,TomoEmptyTable,TomoUse,
      \TomoNumber,TomoFnDecl,TomoBoolean,TomoDocTest,TomoDocError,TomoArray,TomoTable,
      \TomoLinkerDirective,TomoInlineC

if !exists('b:current_syntax')
  let b:current_syntax = 'tomo'
endif
