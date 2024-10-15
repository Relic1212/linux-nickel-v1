#compdef nickel

autoload -U is-at-least

_nickel() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'-h[Print help]' \
'--help[Print help]' \
'-V[Print version]' \
'--version[Print version]' \
":: :_nickel_commands" \
"*::: :->nickel-lang-cli" \
&& ret=0
    case $state in
    (nickel-lang-cli)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:nickel-command-$line[1]:"
        case $line[1] in
            (eval)
_arguments "${_arguments_options[@]}" \
'*-I+[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'*--import-path=[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'--field=[Only query or act on a specific field of the configuration. For example, \`nickel export config.ncl --field machines.servers.remote_builder\` will only evaluate and export the content of the \`remote_builder\` field]:FIELD_PATH: ' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::files -- Input files, omit to read from stdin:_files' \
&& ret=0
;;
(pprint-ast)
_arguments "${_arguments_options[@]}" \
'*-I+[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'*--import-path=[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'--transform[Performs code transformations before printing]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::files -- Input files, omit to read from stdin:_files' \
&& ret=0
;;
(export)
_arguments "${_arguments_options[@]}" \
'-f+[]:FORMAT:(raw json yaml toml)' \
'--format=[]:FORMAT:(raw json yaml toml)' \
'-o+[Output file. Standard output by default]:OUTPUT:_files' \
'--output=[Output file. Standard output by default]:OUTPUT:_files' \
'*-I+[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'*--import-path=[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'--field=[Only query or act on a specific field of the configuration. For example, \`nickel export config.ncl --field machines.servers.remote_builder\` will only evaluate and export the content of the \`remote_builder\` field]:FIELD_PATH: ' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::files -- Input files, omit to read from stdin:_files' \
&& ret=0
;;
(query)
_arguments "${_arguments_options[@]}" \
'*-I+[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'*--import-path=[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'--field=[Only query or act on a specific field of the configuration. For example, \`nickel export config.ncl --field machines.servers.remote_builder\` will only evaluate and export the content of the \`remote_builder\` field]:FIELD_PATH: ' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'--doc[]' \
'--contract[]' \
'--type[]' \
'--default[]' \
'--value[]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::files -- Input files, omit to read from stdin:_files' \
&& ret=0
;;
(typecheck)
_arguments "${_arguments_options[@]}" \
'*-I+[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'*--import-path=[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::files -- Input files, omit to read from stdin:_files' \
&& ret=0
;;
(repl)
_arguments "${_arguments_options[@]}" \
'--history-file=[]:HISTORY_FILE:_files' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(doc)
_arguments "${_arguments_options[@]}" \
'-o+[The path of the generated documentation file. Default to \`~/.nickel/doc/<input-file>.md\` for input \`<input-file>.ncl\`, or to \`~/.nickel/doc/out.md\` if the input is read from stdin]:OUTPUT:_files' \
'--output=[The path of the generated documentation file. Default to \`~/.nickel/doc/<input-file>.md\` for input \`<input-file>.ncl\`, or to \`~/.nickel/doc/out.md\` if the input is read from stdin]:OUTPUT:_files' \
'--format=[The output format for the generated documentation]:FORMAT:(json markdown)' \
'*-I+[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'*--import-path=[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'--field=[Only query or act on a specific field of the configuration. For example, \`nickel export config.ncl --field machines.servers.remote_builder\` will only evaluate and export the content of the \`remote_builder\` field]:FIELD_PATH: ' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'--stdout[Write documentation to stdout. Takes precedence over \`output\`]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::files -- Input files, omit to read from stdin:_files' \
&& ret=0
;;
(format)
_arguments "${_arguments_options[@]}" \
'*-I+[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'*--import-path=[Adds a directory to the list of paths to search for imports in]:IMPORT_PATH:_files' \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'*::files -- Input files, omit to read from stdin:_files' \
&& ret=0
;;
(gen-completions)
_arguments "${_arguments_options[@]}" \
'--color=[Configure when to output messages in color]:COLOR:(auto always never)' \
'--error-format=[Output error messages in a specific format. The schema of serialized errors reflects the way they are currently rendered. This schema is not guaranteed to be stable yet]:ERROR_FORMAT:(text json yaml toml)' \
'-h[Print help]' \
'--help[Print help]' \
':shell:(bash elvish fish powershell zsh)' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
":: :_nickel__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:nickel-help-command-$line[1]:"
        case $line[1] in
            (eval)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(pprint-ast)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(export)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(query)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(typecheck)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(repl)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(doc)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(format)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(gen-completions)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_nickel_commands] )) ||
_nickel_commands() {
    local commands; commands=(
'eval:Evaluate a Nickel program and pretty-print the result' \
'pprint-ast:Converts the parsed representation (AST) back to Nickel source code and prints it. Used for debugging purpose' \
'export:Exports the result to a different format' \
'query:Prints the metadata attached to an attribute, given as a path' \
'typecheck:Typechecks the program but do not run it' \
'repl:Starts a REPL session' \
'doc:Generates the documentation files for the specified nickel file' \
'format:Format Nickel files' \
'gen-completions:Generate shell completion files' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'nickel commands' commands "$@"
}
(( $+functions[_nickel__doc_commands] )) ||
_nickel__doc_commands() {
    local commands; commands=()
    _describe -t commands 'nickel doc commands' commands "$@"
}
(( $+functions[_nickel__help__doc_commands] )) ||
_nickel__help__doc_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help doc commands' commands "$@"
}
(( $+functions[_nickel__eval_commands] )) ||
_nickel__eval_commands() {
    local commands; commands=()
    _describe -t commands 'nickel eval commands' commands "$@"
}
(( $+functions[_nickel__help__eval_commands] )) ||
_nickel__help__eval_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help eval commands' commands "$@"
}
(( $+functions[_nickel__export_commands] )) ||
_nickel__export_commands() {
    local commands; commands=()
    _describe -t commands 'nickel export commands' commands "$@"
}
(( $+functions[_nickel__help__export_commands] )) ||
_nickel__help__export_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help export commands' commands "$@"
}
(( $+functions[_nickel__format_commands] )) ||
_nickel__format_commands() {
    local commands; commands=()
    _describe -t commands 'nickel format commands' commands "$@"
}
(( $+functions[_nickel__help__format_commands] )) ||
_nickel__help__format_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help format commands' commands "$@"
}
(( $+functions[_nickel__gen-completions_commands] )) ||
_nickel__gen-completions_commands() {
    local commands; commands=()
    _describe -t commands 'nickel gen-completions commands' commands "$@"
}
(( $+functions[_nickel__help__gen-completions_commands] )) ||
_nickel__help__gen-completions_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help gen-completions commands' commands "$@"
}
(( $+functions[_nickel__help_commands] )) ||
_nickel__help_commands() {
    local commands; commands=(
'eval:Evaluate a Nickel program and pretty-print the result' \
'pprint-ast:Converts the parsed representation (AST) back to Nickel source code and prints it. Used for debugging purpose' \
'export:Exports the result to a different format' \
'query:Prints the metadata attached to an attribute, given as a path' \
'typecheck:Typechecks the program but do not run it' \
'repl:Starts a REPL session' \
'doc:Generates the documentation files for the specified nickel file' \
'format:Format Nickel files' \
'gen-completions:Generate shell completion files' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'nickel help commands' commands "$@"
}
(( $+functions[_nickel__help__help_commands] )) ||
_nickel__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help help commands' commands "$@"
}
(( $+functions[_nickel__help__pprint-ast_commands] )) ||
_nickel__help__pprint-ast_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help pprint-ast commands' commands "$@"
}
(( $+functions[_nickel__pprint-ast_commands] )) ||
_nickel__pprint-ast_commands() {
    local commands; commands=()
    _describe -t commands 'nickel pprint-ast commands' commands "$@"
}
(( $+functions[_nickel__help__query_commands] )) ||
_nickel__help__query_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help query commands' commands "$@"
}
(( $+functions[_nickel__query_commands] )) ||
_nickel__query_commands() {
    local commands; commands=()
    _describe -t commands 'nickel query commands' commands "$@"
}
(( $+functions[_nickel__help__repl_commands] )) ||
_nickel__help__repl_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help repl commands' commands "$@"
}
(( $+functions[_nickel__repl_commands] )) ||
_nickel__repl_commands() {
    local commands; commands=()
    _describe -t commands 'nickel repl commands' commands "$@"
}
(( $+functions[_nickel__help__typecheck_commands] )) ||
_nickel__help__typecheck_commands() {
    local commands; commands=()
    _describe -t commands 'nickel help typecheck commands' commands "$@"
}
(( $+functions[_nickel__typecheck_commands] )) ||
_nickel__typecheck_commands() {
    local commands; commands=()
    _describe -t commands 'nickel typecheck commands' commands "$@"
}

if [ "$funcstack[1]" = "_nickel" ]; then
    _nickel "$@"
else
    compdef _nickel nickel
fi
