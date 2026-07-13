" Vim syntax file for the Atom programming language (.atm)
" Kept in sync with the Atom lexer/resolver. Covers the module system, structs,
" generics, match, template literals, type annotations, and the Result/Promise
" model.

if exists('b:current_syntax')
  finish
endif

" ─── Keywords ─────────────────────────────────────────────────────────────
" Hard keywords come straight from the lexer's `keywords[]` table; `type`,
" `from`, and `extends` are contextual keywords the parser recognises in
" type/import positions. Groups mirror the tree-sitter capture granularity so
" the colors match (see the highlight links at the bottom).
syntax keyword atomKeyword      break
syntax keyword atomConditional  if else match
syntax keyword atomRepeat       while for in continue
syntax keyword atomReturn       return
syntax keyword atomImport       import export from
syntax keyword atomCoroutine    async await
syntax keyword atomKwOperator   typeof extends
syntax keyword atomThis         this
" `var` / `const` lead a declaration; the following name is a function name
" only when it precedes `(` / a generic `<` (an inferred-return function like
" `var f() {}`), otherwise it is a plain variable and stays default.
syntax keyword atomKeyword      var const skipwhite nextgroup=atomFuncName
" `fn` is the lambda keyword only (`fn(...)`); named functions are type-first
" (`RET name(...)`) or `var name(...)`, so `fn` never leads a name.
syntax keyword atomKwFunction   fn
syntax keyword atomKwType       struct skipwhite nextgroup=atomStructName
syntax keyword atomKwType       type   skipwhite nextgroup=atomTypeName

" ─── Constants ────────────────────────────────────────────────────────────
syntax keyword atomBoolean      true false
syntax keyword atomNull         nil

" ─── Built-in type names ──────────────────────────────────────────────────
" Highlighted anywhere they appear (annotation positions can't be reliably
" distinguished from object-literal keys, so this is intentionally lexical).
" A type that leads a declaration chains into the function name via nextgroup
" (`number fib(...)` -> `fib` is a function); when the next name isn't followed
" by `(`/`<` the funcname match fails and the name (a variable) stays default.
syntax keyword atomType         number string bool any never object Object array Array Promise Result skipwhite nextgroup=atomFuncName

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
" atomFuncName is reached via nextgroup from `var` / `const` / a built-in type
" keyword; it matches only a name that precedes `(` or a generic `<`, so a
" plain variable name (`var x = 5`, `number n = 42`) is left untouched. A
" function whose return type is a user type or generic (`Result<...> f()`)
" can't be detected by regex, so its name stays default (the regex gap).
" atomStructName / atomTypeName are reached from `struct` / `type`, which
" always lead with a name; `type(x)` has no whitespace-separated name, so the
" match simply fails and the keyword stands alone.
syntax match atomFuncName   '\h\w*\ze\s*[(<]' contained
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
      \atomNull,atomKeyword,atomConditional,atomRepeat,atomReturn,atomImport,
      \atomCoroutine,atomKwOperator,atomThis,atomKwFunction,atomKwType,atomType,
      \atomBuiltin,atomNamespace,atomMethod,atomFuncName,atomOperator,
      \atomLineComment,atomBlockComment

" ─── Highlight links ──────────────────────────────────────────────────────
" Linked to Neovim's tree-sitter capture groups so the palette matches the
" tree-sitter-atom highlighting exactly, and tracks whatever colorscheme is
" active. Neovim provides sensible fallbacks for any capture a colorscheme
" doesn't define.
highlight default link atomKeyword       @keyword
highlight default link atomConditional   @keyword.conditional
highlight default link atomRepeat        @keyword.repeat
highlight default link atomReturn        @keyword.return
highlight default link atomImport        @keyword.import
highlight default link atomCoroutine     @keyword.coroutine
highlight default link atomKwOperator    @keyword.operator
highlight default link atomKwFunction    @keyword.function
highlight default link atomKwType        @keyword.type
highlight default link atomThis          @variable.builtin
highlight default link atomBoolean       @boolean
highlight default link atomNull          @constant.builtin
highlight default link atomType          @type
highlight default link atomStructName    @type
highlight default link atomTypeName      @type
highlight default link atomFuncName      @function
highlight default link atomMethod        @function.method.call
highlight default link atomBuiltin       @function.builtin
highlight default link atomNamespace     @module.builtin
highlight default link atomNumber        @number
highlight default link atomString        @string
highlight default link atomTemplate      @string
highlight default link atomTemplateQuote @string
highlight default link atomTemplateDelim @punctuation.special
highlight default link atomEscape        @string.escape
highlight default link atomLineComment   @comment
highlight default link atomBlockComment  @comment
highlight default link atomTodo          @comment.todo
highlight default link atomOperator      @operator

let b:current_syntax = 'atom'
