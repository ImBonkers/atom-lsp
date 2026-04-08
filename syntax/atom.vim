if exists('b:current_syntax')
  finish
endif

" Keywords
syntax keyword atomKeyword var const fn return if else while for in break continue
syntax keyword atomKeyword export import async await this
syntax keyword atomStorageClass var const
syntax keyword atomRepeat while for in
syntax keyword atomConditional if else
syntax keyword atomStatement return break continue export import
syntax keyword atomAsync async await
syntax keyword atomOperator typeof

" Built-in constants
syntax keyword atomBoolean true false
syntax keyword atomNull nil

" Built-in functions
syntax keyword atomBuiltin print println type clock len push pop shift unshift
syntax keyword atomBuiltin join reverse indexOf lastIndexOf includes slice
syntax keyword atomBuiltin toString toNumber split trim trimStart trimEnd
syntax keyword atomBuiltin startsWith endsWith replace replaceAll charAt
syntax keyword atomBuiltin toUpperCase toLowerCase substring keys values entries
syntax keyword atomBuiltin hasOwn assign Math abs ceil floor round sqrt pow
syntax keyword atomBuiltin min max random log sin cos tan PI E parseInt parseFloat

" Numbers
syntax match atomNumber '\<\d[0-9_]*\>'
syntax match atomNumber '\<\d[0-9_]*\.\d[0-9_]*\>'
syntax match atomNumber '\<\d[0-9_]*\.\d[0-9_]*[eE][+-]\=\d[0-9_]*\>'
syntax match atomNumber '\<0[xX][0-9a-fA-F_]\+\>'
syntax match atomNumber '\<0[bB][01_]\+\>'
syntax match atomNumber '\<0[oO][0-7_]\+\>'

" Strings
syntax region atomString start='"' skip='\\"' end='"' contains=atomEscape
syntax region atomString start="'" skip="\\'" end="'" contains=atomEscape
syntax match atomEscape '\\[nrtabfv0\\\"'']' contained
syntax match atomEscape '\\x[0-9a-fA-F]\{2}' contained
syntax match atomEscape '\\u[0-9a-fA-F]\{4}' contained

" Comments
syntax match atomLineComment '//.*$'
syntax region atomBlockComment start='/\*' end='\*/'

" Function declarations
syntax match atomFuncName '\<fn\s\+\zs\w\+\ze\s*('

" Operators
syntax match atomOperatorSym '[+\-*/%<>=!&|^~#?:]'
syntax match atomOperatorSym '\.\.\.'
syntax match atomOperatorSym '++'
syntax match atomOperatorSym '--'
syntax match atomOperatorSym '**'
syntax match atomOperatorSym '&&'
syntax match atomOperatorSym '||'
syntax match atomOperatorSym '=='
syntax match atomOperatorSym '!='
syntax match atomOperatorSym '<='
syntax match atomOperatorSym '>='
syntax match atomOperatorSym '<<'
syntax match atomOperatorSym '>>'

" Highlight links
highlight default link atomKeyword Keyword
highlight default link atomStorageClass StorageClass
highlight default link atomRepeat Repeat
highlight default link atomConditional Conditional
highlight default link atomStatement Statement
highlight default link atomAsync Keyword
highlight default link atomOperator Keyword
highlight default link atomBoolean Boolean
highlight default link atomNull Constant
highlight default link atomBuiltin Function
highlight default link atomNumber Number
highlight default link atomString String
highlight default link atomEscape SpecialChar
highlight default link atomLineComment Comment
highlight default link atomBlockComment Comment
highlight default link atomFuncName Function
highlight default link atomOperatorSym Operator

let b:current_syntax = 'atom'
