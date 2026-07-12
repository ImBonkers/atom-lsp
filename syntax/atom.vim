" Vim syntax file for the Atom programming language (.atm)
" Kept in sync with the Atom lexer/resolver. Covers the module system, structs,
" generics, match, template literals, type annotations, and the Result/Promise
" model.

if exists('b:current_syntax')
  finish
endif

" ─── Keywords ─────────────────────────────────────────────────────────────
" Hard keywords come straight from the lexer's `keywords[]` table; `type`,
" `from`, `is`, and `extends` are contextual keywords the parser recognises in
" type/import positions.
syntax keyword atomStorage      var const
syntax keyword atomConditional  if else match
syntax keyword atomRepeat       while for in
syntax keyword atomStatement    return break continue
syntax keyword atomModule       import export from
syntax keyword atomAsync        async await
syntax keyword atomKeyword      this typeof is asserts extends
" Declaration keywords carry the following name via nextgroup — a plain `\zs`
" match would be clobbered because these words are themselves keywords.
syntax keyword atomKeyword      fn     skipwhite nextgroup=atomFuncName
syntax keyword atomKeyword      struct skipwhite nextgroup=atomStructName
syntax keyword atomKeyword      type   skipwhite nextgroup=atomTypeName

" ─── Constants ────────────────────────────────────────────────────────────
syntax keyword atomBoolean      true false
syntax keyword atomNull         nil

" ─── Built-in type names ──────────────────────────────────────────────────
" Highlighted anywhere they appear (annotation positions can't be reliably
" distinguished from object-literal keys, so this is intentionally lexical).
syntax keyword atomType         number string bool any never object Object array Array Promise Result

" ─── Built-in globals ─────────────────────────────────────────────────────
" Bare-callable functions the runtime registers (capability-gated at runtime).
syntax keyword atomBuiltin      print clock delay
syntax keyword atomBuiltin      Ok Err unwrap unwrapOr isOk isErr isPromise
syntax keyword atomBuiltin      String Number parseInt parseFloat toString
syntax keyword atomBuiltin      readFile writeFile appendFile fileExists
syntax keyword atomBuiltin      connect listen accept send recv close
" Namespace objects (math.sin, json.parse, os.env, ...).
syntax keyword atomNamespace    math json os

" ─── Numbers ──────────────────────────────────────────────────────────────
syntax match atomNumber '\<\d[0-9_]*\>'
syntax match atomNumber '\<\d[0-9_]*\.\d[0-9_]*\>'
syntax match atomNumber '\<\d[0-9_]*\.\d[0-9_]*[eE][+-]\=\d[0-9_]*\>'
syntax match atomNumber '\<\d[0-9_]*[eE][+-]\=\d[0-9_]*\>'
syntax match atomNumber '\<0[xX][0-9a-fA-F_]\+\>'
syntax match atomNumber '\<0[bB][01_]\+\>'
syntax match atomNumber '\<0[oO][0-7_]\+\>'

" ─── Escape sequences ─────────────────────────────────────────────────────
" `\`` and `\$` are template escapes; the single-quoted pattern writes a
" literal quote as `''`.
syntax match atomEscape '\\[nrtabfv0\\"''`$]' contained
syntax match atomEscape '\\x[0-9a-fA-F]\{2}' contained
syntax match atomEscape '\\u[0-9a-fA-F]\{4}' contained

" ─── Strings ──────────────────────────────────────────────────────────────
syntax region atomString start='"' skip='\\"' end='"' contains=atomEscape keepend
syntax region atomString start="'" skip="\\'" end="'" contains=atomEscape keepend

" ─── Template literals ────────────────────────────────────────────────────
" Backtick strings with `${ expr }` interpolation (single-line).
syntax region atomTemplate matchgroup=atomTemplateQuote start='`' skip='\\`' end='`'
      \ contains=atomEscape,atomInterp keepend
syntax region atomInterp matchgroup=atomTemplateDelim start='\${' end='}'
      \ contained contains=@atomExpr

" ─── Comments ─────────────────────────────────────────────────────────────
syntax keyword atomTodo contained TODO FIXME XXX HACK NOTE
syntax match  atomLineComment  '//.*$' contains=atomTodo
syntax region atomBlockComment start='/\*' end='\*/' contains=atomTodo

" ─── Declaration names ────────────────────────────────────────────────────
" Reached via nextgroup from `fn` / `struct` / `type` (see above). `fn(` and
" `type(x)` have no whitespace-separated name, so the name match simply fails
" and the keyword stands alone.
syntax match atomFuncName   '\h\w*' contained
syntax match atomStructName '\h\w*' contained
syntax match atomTypeName   '\h\w*' contained

" ─── Method calls ─────────────────────────────────────────────────────────
" An identifier that follows `.` and precedes `(` (arr.map(...), s.trim(), ...).
syntax match atomMethod '\.\zs\w\+\ze\s*('

" ─── Operators ────────────────────────────────────────────────────────────
syntax match atomOperator '[-+*/%<>=!&|^~#?:]'
syntax match atomOperator '->'
syntax match atomOperator '\.\.\.'
syntax match atomOperator '++'
syntax match atomOperator '--'
syntax match atomOperator '\*\*'
syntax match atomOperator '&&'
syntax match atomOperator '||'
syntax match atomOperator '=='
syntax match atomOperator '!='
syntax match atomOperator '<='
syntax match atomOperator '>='
syntax match atomOperator '<<'
syntax match atomOperator '>>'

" ─── Interpolation expression cluster ─────────────────────────────────────
syntax cluster atomExpr contains=atomNumber,atomString,atomTemplate,atomBoolean,
      \atomNull,atomStorage,atomConditional,atomRepeat,atomStatement,atomModule,
      \atomAsync,atomKeyword,atomType,atomBuiltin,atomNamespace,atomMethod,
      \atomFuncName,atomOperator,atomLineComment,atomBlockComment

" ─── Highlight links ──────────────────────────────────────────────────────
highlight default link atomStorage       StorageClass
highlight default link atomConditional   Conditional
highlight default link atomRepeat        Repeat
highlight default link atomStatement      Statement
highlight default link atomModule        Include
highlight default link atomAsync         Statement
highlight default link atomKeyword       Statement
highlight default link atomBoolean       Boolean
highlight default link atomNull          Constant
highlight default link atomType          Type
highlight default link atomStructName    Type
highlight default link atomTypeName      Type
highlight default link atomBuiltin       Function
highlight default link atomNamespace     Structure
highlight default link atomNumber        Number
highlight default link atomString        String
highlight default link atomTemplate      String
highlight default link atomTemplateQuote String
highlight default link atomTemplateDelim Special
highlight default link atomEscape        SpecialChar
highlight default link atomLineComment   Comment
highlight default link atomBlockComment  Comment
highlight default link atomTodo          Todo
highlight default link atomFuncName      Function
highlight default link atomMethod        Function
highlight default link atomOperator      Operator

let b:current_syntax = 'atom'
