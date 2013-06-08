(in-package "xtal-mode")
(define-abbrev-table '*xtal-mode-abbrev-table* '(
))

(in-package "xml")
(define-abbrev-table '*xml-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*scheme-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*ruby-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*py-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*php-mode-abbrev-table* '(
))

(in-package "elisp")
(define-abbrev-table 'makefile-mode-abbrev-table '(
))

(in-package "editor")
(define-abbrev-table '*lua-mode-abbrev-table* '(
))

(in-package "user")
(define-abbrev-table '*elisp-mode-abbrev-table* '(
))

(in-package "elisp")
(define-abbrev-table '*kahtml-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*jscript-mode-abbrev-table* '(
  ("remarks" "/// <remarks>
$INDENT/// ${1:description}
$INDENT/// </remarks>$0" nil 0)
  ("with" "with(${1:Symbol}) {
$INDENT$0
}$INDENT" nil 0)
  ("case" "case ${1:Argument}:$INDENT
$INDENT$0
$INDENTbreak;" nil 0)
  ("list" "/// <list type=\"${1:bullet | number | table}\">
$INDENT/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>
$INDENT/// </list>$0" nil 0)
  ("catch" "catch(${1:CatchParameter}) {
$INDENT$0
}$INDENT" nil 0)
  ("value" "/// <value>${1:property-description}</value>" nil 0)
  ("c" "<c>${1:test}</c>$0" nil 0)
  ("item" "/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>$0" nil 0)
  ("term" "/// <term>${1:term}</term>$0" nil 0)
  ("elif" "else if(${1:IfCondition}) {
$INDENT$0
}$INDENT" nil 0)
  ("include" "/// <include file=\"${1:filename}\" path=\"${2:tagpath}[@${3:name}=\"${4:id}\"]\">$0" nil 0)
  ("while" "while(${1:Expression}) {
$INDENT$0
}$INDENT" nil 0)
  ("paramref" "<paramref name=\"${1:name}\"/>$0" nil 0)
  ("param" "/// <param name=\"${1:name}\">${2:description}</param>$0" nil 0)
  ("exception" "/// <exception cref=\"${1:member}\">${2:description}</exception>$0" nil 0)
  ("permission" "/// <permission cref=\"${1:member}\">${1:description}</permission>$0" nil 0)
  ("foreach" "for(${1:ForeachType} in ${2:Aggregate}) {
$INDENT$0
}$INDENT" nil 0)
  ("else" "else {
$INDENT$0
}$INDENT" nil 0)
  ("seealso" "/// <seealso cref=\"${1:member}\"/>$0" nil 0)
  ("elseif" "else if(${1:IfCondition}) {
$INDENT$0
}$INDENT" nil 0)
  ("summary" "/// <summary>
$INDENT/// ${1:description}
$INDENT/// </summary>$0" nil 0)
  ("finally" "finally {
$INDENT$0
}$INDENT" nil 0)
  ("try" "try {
$INDENT$0
}$INDENT" nil 0)
  ("example" "/// <example>
$INDENT/// ${1:description}
$INDENT/// </example>$0" nil 0)
  ("listheader" "/// <listheader>
$INDENT/// <description>${1:description}</description>
$INDENT/// </listheader>$0" nil 0)
  ("region" "// @region ${1:description}

$INDENT$0

$INDENT// @endregion" nil 0)
  ("returns" "/// <returns>${1:description}</returns>$0" nil 0)
  ("switch" "switch(${1:Expression}) {
case ${2:Argument}:$INDENT
$INDENT$0
$INDENTbreak;
}$INDENT" nil 0)
  ("if" "if(${1:IfCondition}) {
$INDENT$0
}$INDENT" nil 0)
  ("code" "/// <code>
$INDENT/// ${1:content}
$INDENT/// </code>$0" nil 0)
  ("typeparam" "/// <typeparam name=\"${1:name}\">${2:description}</typeparam>$0" nil 0)
  ("for" "for(${1:Initialize}; ${2:Test}; ${3:Increment}) {
$INDENT$0
}$INDENT" nil 0)
  ("function" "function${1/./ }${1:Identifer}(${2:ArgumentList}) {
$INDENT$0
};$INDENT" nil 0)
  ("typeparamref" "/// <typeparamref name=\"${1:name}\"/>$0" nil 0)
  ("foreach1.6" "forEach(function(${1:Argument}) {
$INDENT$0
});$INDENT" nil 0)
  ("para" "<para>${1:description}</para>$0" nil 0)
  ("see" "<see cref=\"${1:member}\"/>$0" nil 0)
  ("dowhile" "do {
$INDENT$0
} while(${1:Expression});$INDENT" nil 0)
))

(in-package "elisp-lib")
(define-abbrev-table 'howm-view-contents-mode-abbrev-table '(
))

(in-package "elisp-lib")
(define-abbrev-table 'howm-view-summary-mode-abbrev-table '(
))

(in-package "elisp-lib")
(define-abbrev-table 'riffle-sample-contents-mode-abbrev-table '(
))

(in-package "elisp-lib")
(define-abbrev-table 'riffle-sample-summary-mode-abbrev-table '(
))

(in-package "elisp-lib")
(define-abbrev-table 'riffle-contents-mode-abbrev-table '(
))

(in-package "elisp-lib")
(define-abbrev-table 'riffle-summary-mode-abbrev-table '(
))

(in-package "editor")
(define-abbrev-table '*gauche-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*fsharp-mode-abbrev-table* '(
  ("remarks" "/// <remarks>
$INDENT/// ${1:description}
$INDENT/// </remarks>$0" nil 0)
  ("list" "/// <list type=\"${1:bullet | number | table}\">
$INDENT/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>
$INDENT/// </list>$0" nil 0)
  ("example" "/// <example>
$INDENT/// ${1:description}
$INDENT/// </example>$0" nil 0)
  ("c" "<c>${1:test}</c>$0" nil 0)
  ("item" "/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>$0" nil 0)
  ("seealso" "/// <seealso cref=\"${1:member}\"/>$0" nil 0)
  ("exception" "/// <exception cref=\"${1:member}\">${2:description}</exception>$0" nil 0)
  ("include" "/// <include file=\"${1:filename}\" path=\"${2:tagpath}[@${3:name}=\"${4:id}\"]\">$0" nil 0)
  ("paramref" "<paramref name=\"${1:name}\"/>$0" nil 0)
  ("summary" "/// <summary>
$INDENT/// ${1:description}
$INDENT/// </summary>$0" nil 0)
  ("term" "/// <term>${1:term}</term>$0" nil 0)
  ("permission" "/// <permission cref=\"${1:member}\">${1:description}</permission>$0" nil 0)
  ("param" "/// <param name=\"${1:name}\">${2:description}</param>$0" nil 0)
  ("returns" "/// <returns>${1:description}</returns>$0" nil 0)
  ("code" "/// <code>
$INDENT/// ${1:content}
$INDENT/// </code>$0" nil 0)
  ("typeparam" "/// <typeparam name=\"${1:name}\">${2:description}</typeparam>$0" nil 0)
  ("typeparamref" "/// <typeparamref name=\"${1:name}\"/>$0" nil 0)
  ("value" "/// <value>${1:property-description}</value>" nil 0)
  ("para" "<para>${1:description}</para>$0" nil 0)
  ("see" "<see cref=\"${1:member}\"/>$0" nil 0)
  ("listheader" "/// <listheader>
$INDENT/// <description>${1:description}</description>
$INDENT/// </listheader>$0" nil 0)
))

(in-package "editor")
(define-abbrev-table '*d-mode-abbrev-table* '(
  ("with" "with(${1:Symbol}) {
$INDENT$0
}$INDENT" nil 0)
  ("catch" "catch${1/./(}${1:CatchParameter}${1/./)} {
$INDENT$0
}$INDENT" nil 0)
  ("try" "try {
$INDENT$0
}$INDENT" nil 0)
  ("union" "union ${1:Identifier}${1/./ }{
$INDENT$0
}$INDENT" nil 0)
  ("syncronized" "synchronized${1/./(}${1:Symbol}${1/./)} {
$INDENT$0
}$INDENT" nil 0)
  ("enum" "enum ${1:EnumTag}${1/./ }${2/./: }${2:EnumBaseType}${2/./ }{
$INDENT$0
}$INDENT" nil 0)
  ("foreach" "foreach(${1:ForeachType}; ${2:Aggregate}) {
$INDENT$0
}$INDENT" nil 0)
  ("case" "case ${1:ArgumentList}:$INDENT
$INDENT$0
$INDENTbreak;" nil 0)
  ("elseif" "else if(${1:IfCondition}) {
$INDENT$0
}$INDENT" nil 0)
  ("finally" "finally {
$INDENT$0
}$INDENT" nil 0)
  ("struct" "struct ${1:Identifier}${1/./ }{
$INDENT$0
}$INDENT" nil 0)
  ("else" "else {
$INDENT$0
}$INDENT" nil 0)
  ("switch" "switch(${1:Expression}) {
case ${2:ArgumentList}:$INDENT
$INDENT$0
$INDENTbreak;
default:$INDENT
$INDENTbreak;
}$INDENT" nil 0)
  ("cast" "cast(${1:Type})${0:XYZZY-SELECTION}" nil 0)
  ("sync" "synchronized${1/./(}${1:Symbol}${1/./)} {
$INDENT$0
}$INDENT" nil 0)
  ("for" "for(${1:Initialize}; ${2:Test}; ${3:Increment}) {
$INDENT$0
}$INDENT" nil 0)
  ("elif" "else if(${1:IfCondition}) {
$INDENT$0
}$INDENT" nil 0)
  ("if" "if(${1:IfCondition}) {
$INDENT$0
}$INDENT" nil 0)
  ("to" "to!(${1:Type})( ${0:XYZZY-SELECTION} )" nil 0)
  ("while" "while(${1:Expression}) {
$INDENT$0
}$INDENT" nil 0)
  ("dowhile" "do {
$INDENT$0
} while(${1:Expression});$INDENT" nil 0)
  ("class" "class ${1:Identifier}${2/./ : }${2:BaseClass} {
$INDENT$0
}$INDENT" nil 0)
  ("final-switch" "final switch(${1:Expression}) {
case ${2:ArgumentList}:$INDENT
$INDENT$0
$INDENTbreak;
}$INDENT" nil 0)
  ("interface" "interface ${1:Identifier} {
$INDENT$0
}$INDENT" nil 0)
))

(in-package "editor")
(define-abbrev-table '*caml-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*bat-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*bash-mode-abbrev-table* '(
  ("case" "case ${1:Expression} in
$INDENT${2:Argument} )
$INDENT	$0
$INDENT	;;
$INDENTesac" nil 0)
  ("for" "for ${1:ForeachType} in ${2:Aggregate}; do
$INDENT	$0
$INDENTdone" nil 0)
  ("until" "until ${1:Expression}; do
$INDENT	$0
$INDENTdone" nil 0)
  ("while" "while ${1:Expression}; do
$INDENT	$0
$INDENTdone" nil 0)
  ("if" "if ${1:IfCondition}; then
$INDENT	$0
$INDENTfi" nil 0)
))

(in-package "editor")
(define-abbrev-table '*asm-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*ahk-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*html+-mode-abbrev-table* '(
  ("strong" "<strong>${0:XYZZY-SELECTION}</strong>" nil 0)
  ("td" "<td>
$INDENT${0:XYZZY-SELECTION}
</td>$INDENT" nil 0)
  ("th" "<th>
$INDENT${0:XYZZY-SELECTION}
</th>$INDENT" nil 0)
  ("anchor" "<a href=\"${1:url}\">${0:XYZZY-SELECTION}</a>" nil 0)
  ("ruby" "<ruby>${0:XYZZY-SELECTION}</ruby>" nil 0)
  ("css" "<link rel=\"stylesheet\" href=\"${1:./foo.css}\" type=\"text/css\" />$0" nil 0)
  ("tr" "<tr>
$INDENT${0:XYZZY-SELECTION}
</tr>$INDENT" nil 0)
  ("ul" "<ul>
$INDENT${0:XYZZY-SELECTION}
</ul>$INDENT" nil 0)
  ("li" "<li>${0:XYZZY-SELECTION}</li>" nil 0)
  ("class=" "class=\"${1:name}\"$0" nil 0)
  ("title" "<title>${0:XYZZY-SELECTION}</title>" nil 0)
  ("php" "<?php
$0
?>" nil 0)
  ("iso-2022" "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-2022-jp\">" nil 0)
  ("tag" "<${1:p}>
${0:XYZZY-SELECTION}
</${1/[^ >]*/\\0}>" nil 0)
  ("utf-8" "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />" nil 0)
  ("table" "<table>
$INDENT${0:XYZZY-SELECTION}
</table>$INDENT" nil 0)
  ("h1" "<h1>${0:XYZZY-SELECTION}</h1>" nil 0)
  ("h2" "<h2>${0:XYZZY-SELECTION}</h2>" nil 0)
  ("sjis" "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=Shift_JIS\" />" nil 0)
  ("h4" "<h4>${0:XYZZY-SELECTION}</h4>" nil 0)
  ("h5" "<h5>${0:XYZZY-SELECTION}</h5>" nil 0)
  ("h6" "<h6>${0:XYZZY-SELECTION}</h6>" nil 0)
  ("id=" "id=\"${1:name}\"$0" nil 0)
  ("em" "<em>${0:XYZZY-SELECTION}</em>" nil 0)
  ("h3" "<h3>${0:XYZZY-SELECTION}</h3>" nil 0)
  ("ol" "<ol>
$INDENT${0:XYZZY-SELECTION}
</ol>$INDENT" nil 0)
  ("a" "<a href=\"${1:url}\">${0:XYZZY-SELECTION}</a>" nil 0)
  ("html" "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ja\" lang=\"ja\">
$INDENT<head>
$INDENT<title>${1:title}</title>
</head>$INDENT
$INDENT<body>
$INDENT$0
</body>$INDENT
</html>
" nil 0)
  ("pre" "<pre>
$INDENT${0:XYZZY-SELECTION}
</pre>" nil 0)
  ("script" "<script type=\"text/javascript\"${1/./ src=\"}${1:./foo.js}${1/./\"}>$0</script>" nil 0)
  ("p" "<p${1/./ id=\"}${1:name}${1/./\"}>
$INDENT${0:XYZZY-SELECTION}
</p>$INDENT" nil 0)
  ("euc" "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-jp\" />" nil 0)
  ("img" "<img src=\"${1:file}\" />" nil 0)
  ("sub" "<sub>${0:XYZZY-SELECTION}</sub>" nil 0)
  ("doctype" "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"
    \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">
" nil 0)
  ("div" "<div${1/./ id=\"}${1:name}${1/./\"}>
$INDENT${0:XYZZY-SELECTION}
</div>$INDENT" nil 0)
  ("sup" "<sup>${0:XYZZY-SELECTION}</sup>" nil 0)
  ("span" "<span${1/./ id=\"}${1:name}${1/./\"}>${0:XYZZY-SELECTION}</span>" nil 0)
))

(in-package "editor")
(define-abbrev-table '*css+-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*sql-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*perl-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*pascal-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*LaTeX-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*java-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*csharp-mode-abbrev-table* '(
  ("returns" "/// <returns>${1:description}</returns>$0" nil 0)
  ("else" "else
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("const-array" "ReadOnlyCollection<${1:BasicType}> ${2:Identifier} = Array.AsReadOnly<${1/.*/\\0}>( new ${1/.*/\\0}[] {
$INDENT$0
} );$INDENT" nil 0)
  ("elseif" "else if( ${1:IfCondition} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("typeparamref" "/// <typeparamref name=\"${1:name}\"/>$0" nil 0)
  ("case" "case ${1:Argument}:$INDENT
$INDENT$0
$INDENTbreak;" nil 0)
  ("catch" "catch${1/./( }${1:CatchParameter}${1/./ )}
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("struct" "struct ${1:Identifier}
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("example" "/// <example>
$INDENT/// ${1:description}
$INDENT/// </example>$0" nil 0)
  ("foreach" "foreach( ${1:ForeachType} in ${2:Aggregate} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("cast" "(${1:Type})${0:XYZZY-SELECTION}" nil 0)
  ("value" "/// <value>${1:property-description}</value>" nil 0)
  ("item" "/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>$0" nil 0)
  ("term" "/// <term>${1:term}</term>$0" nil 0)
  ("try" "try
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("paramref" "<paramref name=\"${1:name}\"/>$0" nil 0)
  ("para" "<para>${1:description}</para>$0" nil 0)
  ("listheader" "/// <listheader>
$INDENT/// <description>${1:description}</description>
$INDENT/// </listheader>$0" nil 0)
  ("seealso" "/// <seealso cref=\"${1:member}\"/>$0" nil 0)
  ("region" "#region ${1:description}

$INDENT$0

$INDENT#endregion" nil 0)
  ("while" "while( ${1:Expression} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("param" "/// <param name=\"${1:name}\">${2:description}</param>$0" nil 0)
  ("see" "<see cref=\"${1:member}\"/>$0" nil 0)
  ("switch" "switch( ${1:Expression} )
{$INDENT
case ${2:Argument}:$INDENT
$INDENT$0
$INDENTbreak;
}$INDENT" nil 0)
  ("permission" "/// <permission cref=\"${1:member}\">${1:description}</permission>$0" nil 0)
  ("code" "/// <code>
$INDENT/// ${1:content}
$INDENT/// </code>$0" nil 0)
  ("remarks" "/// <remarks>
$INDENT/// ${1:description}
$INDENT/// </remarks>$0" nil 0)
  ("list" "/// <list type=\"${1:bullet | number | table}\">
$INDENT/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>
$INDENT/// </list>$0" nil 0)
  ("c" "<c>${1:test}</c>$0" nil 0)
  ("class" "class ${1:Identifier}${2/./ : }${2:BaseClass}
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("typeparam" "/// <typeparam name=\"${1:name}\">${2:description}</typeparam>$0" nil 0)
  ("enum" "enum ${1:EnumTag}${2/./ : }${2:EnumBaseType}
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("exception" "/// <exception cref=\"${1:member}\">${2:description}</exception>$0" nil 0)
  ("summary" "/// <summary>
$INDENT/// ${1:description}
$INDENT/// </summary>$0" nil 0)
  ("dowhile" "do
{$INDENT
$INDENT$0
} while( ${1:Expression} );$INDENT" nil 0)
  ("include" "/// <include file=\"${1:filename}\" path=\"${2:tagpath}[@${3:name}=\"${4:id}\"]\">$0" nil 0)
  ("for" "for( ${1:Initialize}; ${2:Test}; ${3:Increment} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("if" "if( ${1:IfCondition} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("finally" "finally
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("elif" "else if( ${1:IfCondition} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
))

(in-package "editor")
(define-abbrev-table '*basic-mode-abbrev-table* '(
  ("returns" "''' <returns>${1:description}</returns>$0" nil 0)
  ("else" "Else
$INDENT$0" nil 0)
  ("const-array" "ReadOnlyCollection( Of ${1:BasicType} ) ${2:Identifier} = Array.AsReadOnly( Of ${1/.*/\\0} )( New ${1/.*/\\0}() {
$INDENT$0
} )$INDENT" nil 0)
  ("elseif" "Else If ${1:IfCondition} Then
$INDENT$0" nil 0)
  ("typeparamref" "''' <typeparamref name=\"${1:name}\"/>$0" nil 0)
  ("case" "Case ${1:Argument}$INDENT
$INDENT$0" nil 0)
  ("select" "Select ${1:Expression}
Case ${2:Argument}$INDENT
$INDENT$0
End Select$INDENT" nil 0)
  ("struct" "Struct ${1:Identifier}
$INDENT$0
End Struct$INDENT" nil 0)
  ("example" "''' <example>
$INDENT''' ${1:description}
$INDENT''' </example>$0" nil 0)
  ("foreach" "For Each ${1:ForeachType} In ${2:Aggregate}
$INDENT$0
Next$INDENT" nil 0)
  ("cast" "C${1:Type}( ${0:XYZZY-SELECTION} )" nil 0)
  ("value" "''' <value>${1:property-description}</value>" nil 0)
  ("item" "''' <item>
$INDENT''' <description>${1:description}</description>
$INDENT''' </item>$0" nil 0)
  ("term" "''' <term>${1:term}</term>$0" nil 0)
  ("try" "Try
$INDENT$0
End Try$INDENT" nil 0)
  ("paramref" "<paramref name=\"${1:name}\"/>$0" nil 0)
  ("para" "<para>${1:description}</para>$0" nil 0)
  ("listheader" "''' <listheader>
$INDENT''' <description>${1:description}</description>
$INDENT''' </listheader>$0" nil 0)
  ("seealso" "''' <seealso cref=\"${1:member}\"/>$0" nil 0)
  ("region" "#Region \"${1:description}\"

$INDENT$0

$INDENT#End Region" nil 0)
  ("while" "While ${1:Expression}
$INDENT$0
End While$INDENT" nil 0)
  ("param" "''' <param name=\"${1:name}\">${2:description}</param>$0" nil 0)
  ("see" "<see cref=\"${1:member}\"/>$0" nil 0)
  ("switch" "Select ${1:Expression}
Case ${2:Argument}$INDENT
$INDENT$0
End Select$INDENT" nil 0)
  ("permission" "''' <permission cref=\"${1:member}\">${1:description}</permission>$0" nil 0)
  ("code" "''' <code>
$INDENT''' ${1:content}
$INDENT''' </code>$0" nil 0)
  ("remarks" "''' <remarks>
$INDENT''' ${1:description}
$INDENT''' </remarks>$0" nil 0)
  ("list" "''' <list type=\"${1:bullet | number | table}\">
$INDENT''' <item>
$INDENT''' <description>${1:description}</description>
$INDENT''' </item>
$INDENT''' </list>$0" nil 0)
  ("c" "<c>${1:test}</c>$0" nil 0)
  ("class" "Class ${1:Identifier}${2/./ : Implements }${2:BaseClass}
$INDENT$0
End Class$INDENT" nil 0)
  ("typeparam" "''' <typeparam name=\"${1:name}\">${2:description}</typeparam>$0" nil 0)
  ("catch" "Catch ${1:CatchParameter}
$INDENT$0" nil 0)
  ("enum" "Enum ${1:EnumTag}${2/./ As }${2:EnumBaseType}
$INDENT$0
End Enum$INDENT" nil 0)
  ("exception" "''' <exception cref=\"${1:member}\">${2:description}</exception>$0" nil 0)
  ("summary" "''' <summary>
$INDENT''' ${1:description}
$INDENT''' </summary>$0" nil 0)
  ("dowhile" "Do
$INDENT$0
Loop While ${1:Expression}$INDENT" nil 0)
  ("include" "''' <include file=\"${1:filename}\" path=\"${2:tagpath}[@${3:name}=\"${4:id}\"]\">$0" nil 0)
  ("For Each" "foreach ${1:ForeachType} In ${2:Aggregate}
$INDENT$0
Next$INDENT" nil 0)
  ("for" "For ${1:Initialize} To ${2:Test}${3/./ Step }${3:Increment} )
$INDENT$0
Next$INDENT" nil 0)
  ("if" "If ${1:IfCondition} Then
$INDENT$0
End If$INDENT" nil 0)
  ("finally" "Finally
$INDENT$0" nil 0)
  ("elif" "Else If ${1:IfCondition} Then
$INDENT$0" nil 0)
))

(in-package "editor")
(define-abbrev-table '*text-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*c++-mode-abbrev-table* '(
  ("returns" "/// <returns>${1:description}</returns>$0" nil 0)
  ("safe_cast" "safe_cast<${1:Type}>( ${0:XYZZY-SELECTION} )" nil 0)
  ("summary" "/// <summary>
$INDENT/// ${1:description}
$INDENT/// </summary>$0" nil 0)
  ("else" "else
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("union" "union ${1:Identifier}
{$INDENT
$INDENT$0
};$INDENT" nil 0)
  ("typedef" "typedef ${1:Identifier} ${2:Identifier};" nil 0)
  ("elseif" "else if( ${1:IfCondition} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("dynamic_cast" "dynamic_cast<${1:Type}>( ${0:XYZZY-SELECTION} )" nil 0)
  ("typeparamref" "/// <typeparamref name=\"${1:name}\"/>$0" nil 0)
  ("static_cast" "static_cast<${1:Type}>( ${0:XYZZY-SELECTION} )" nil 0)
  ("catch" "catch( ${1:CatchParameter} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("struct" "struct ${1:Identifier}
{$INDENT
$INDENT$0
};$INDENT" nil 0)
  ("example" "/// <example>
$INDENT/// ${1:description}
$INDENT/// </example>$0" nil 0)
  ("foreach" "for each( ${1:ForeachType} in ${2:Aggregate} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("cast" "(${1:Type})${0:XYZZY-SELECTION}" nil 0)
  ("value" "/// <value>${1:property-description}</value>" nil 0)
  ("item" "/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>$0" nil 0)
  ("term" "/// <term>${1:term}</term>$0" nil 0)
  ("try" "try
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("paramref" "<paramref name=\"${1:name}\"/>$0" nil 0)
  ("para" "<para>${1:description}</para>$0" nil 0)
  ("listheader" "/// <listheader>
$INDENT/// <description>${1:description}</description>
$INDENT/// </listheader>$0" nil 0)
  ("seealso" "/// <seealso cref=\"${1:member}\"/>$0" nil 0)
  ("region" "#pragma region ${1:description}

$INDENT$0

$INDENT#pragma endregion" nil 1)
  ("while" "while( ${1:Expression} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("param" "/// <param name=\"${1:name}\">${2:description}</param>$0" nil 0)
  ("see" "<see cref=\"${1:member}\"/>$0" nil 0)
  ("switch" "switch( ${1:Expression} ) {
case ${2:Argument}:$INDENT
$INDENT$0
$INDENTbreak;
}$INDENT" nil 0)
  ("const_cast" "const_cast<${1:Type}>( ${0:XYZZY-SELECTION} )" nil 0)
  ("permission" "/// <permission cref=\"${1:member}\">${1:description}</permission>$0" nil 0)
  ("code" "/// <code>
$INDENT/// ${1:content}
$INDENT/// </code>$0" nil 0)
  ("reinterpret_cast" "reinterpret_cast<${1:Type}>( ${0:XYZZY-SELECTION} )" nil 0)
  ("remarks" "/// <remarks>
$INDENT/// ${1:description}
$INDENT/// </remarks>$0" nil 0)
  ("case" "case ${1:Argument}:$INDENT
$INDENT$0
$INDENTbreak;" nil 0)
  ("list" "/// <list type=\"${1:bullet | number | table}\">
$INDENT/// <item>
$INDENT/// <description>${1:description}</description>
$INDENT/// </item>
$INDENT/// </list>$0" nil 0)
  ("c" "<c>${1:test}</c>$0" nil 0)
  ("class" "class ${1:Identifier}${2/./ : }${2:BaseClass}
{$INDENT
$INDENT$0
};$INDENT" nil 0)
  ("typeparam" "/// <typeparam name=\"${1:name}\">${2:description}</typeparam>$0" nil 0)
  ("enum" "enum ${1:EnumTag}
{$INDENT
$INDENT$0
};$INDENT" nil 0)
  ("exception" "/// <exception cref=\"${1:member}\">${2:description}</exception>$0" nil 0)
  ("dowhile" "do
{$INDENT
$INDENT$0
} while( ${1:Expression} );$INDENT" nil 0)
  ("include" "/// <include file=\"${1:filename}\" path=\"${2:tagpath}[@${3:name}=\"${4:id}\"]\">$0" nil 0)
  ("for" "for( ${1:Initialize}; ${2:Test}; ${3:Increment} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("if" "if( ${1:IfCondition} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
  ("elif" "else if( ${1:IfCondition} )
{$INDENT
$INDENT$0
}$INDENT" nil 0)
))

(in-package "editor")
(define-abbrev-table '*c-mode-abbrev-table* '(
))

(in-package "editor")
(define-abbrev-table '*lisp-mode-abbrev-table* '(
  (":reverse " ":reverse t" nil 0)
  ("msgbox" "(msgbox \"${1/\\(\\sw\\|\\s_\\)+/\\0: ~S~%/g}\" ${1:VAR})" nil 0)
  (":case-fold " ":case-fold ${1::smart}$0" nil 0)
  ("goto-max" "(goto-char (point-max))" nil 0)
  ("lambda" "#'(lambda (${1:LAMBDA-LIST})
$INDENT$0
$INDENT)" nil 0)
  ("add-history" "(add-history ${1:ITEM} '${2:VAR})$0" nil 0)
  ("provide" "(provide \"${1:XYZZY-FILE-PATHNAME-NAME}\")$0" nil 0)
  ("delete-hook" "(delete-hook '${1:HOOK} ${2:FN})$0" nil 0)
  (":direction " ":direction ${1::output}$0" nil 0)
  (":if-exists " ":if-exists ${1::newer}$0" nil 0)
  ("interactive" "(interactive${1/^[^(]/ \"}${1:INTERACTIVE-STRING}${1/^[^(]/\"})$0" nil 0)
  (":test " ":test ${1:'equal}$0" nil 0)
  (":tail " ":tail t" nil 0)
  ("add-hook" "(add-hook '${1:HOOK} ${2:FN})$0" nil 0)
  (":no-dup " ":no-dup t" nil 0)
  ("goto-min" "(goto-char (point-min))" nil 0)
  (":regexp " ":regexp t" nil 0)
  (":if-access-denied " ":if-access-denied ${1::skip}$0" nil 0)
  (":key " ":key ${1:'car}$0" nil 0)
  (":if-does-not-exist " ":if-does-not-exist ${1::create}$0" nil 0)
  ("defun" "(defun ${1:NAME} (${2:LAMBDA-LIST})
$INDENT${3/./\"}${3:DOCUMENTATION}${3/./\"
$INDENT}$0
$INDENT)" nil 0)
  ("in-package" "(in-package \"${1:editor}\")$0" nil 0)
  ("run-hooks" "(run-hooks '${1:HOOK})$0" nil 0)
  (":test-not " ":test-not '${1:'equal}$0" nil 0)
  ("export" "(export '($0))
" nil 0)
))

(in-package "editor")
(define-abbrev-table '*global-abbrev-table* '(
))

