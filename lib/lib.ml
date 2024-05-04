let is_upper c =
  let code = Char.code c in
  code >= 65 && code <= 90
;;

let is_reserved = function
| "and" | "as" | "assert" | "asr" | "begin" | "class" | "constraint" | "do"
| "done" | "downto" | "else" | "end" | "exception" | "external" | "false"
| "for" | "fun" | "function" | "functor" | "if" | "in" | "include"
| "inherit" | "initializer" | "land" | "lazy" | "let" | "lor" | "lsl" | "lsr"
| "lxor" | "match" | "method" | "mod" | "module" | "mutable" | "new"
| "nonrec" | "object" | "of" | "open" | "or" | "private" | "rec" | "sig"
| "struct" | "then" | "to" | "true" | "try" | "type" | "val" | "virtual"
| "when" | "while" | "with" | "selector" | "id" | "string" -> true
| _ -> false

let is_private sel =
  Char.equal (String.get sel 0) '.' || String.contains sel '_'
;;

let valid_name name =
  if is_upper (String.get name 0) then "_" ^ name
  else if is_reserved name then name ^ "_"
  else name
;;

let remove_empty str_list =
  str_list |> List.filter_map @@ fun a ->
    if String.equal a String.empty then
      Option.none
    else
      Option.some a
;;

let split_selector sel =
  match String.split_on_char ':' sel with
  | [] -> assert false
  | name :: args ->
    match args with
    | [] ->
      (valid_name name, [])
    | xs ->
      let xs' = remove_empty xs |> List.map valid_name in
      (valid_name name, "x" :: xs')
;;