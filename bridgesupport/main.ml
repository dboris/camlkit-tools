open Runtime
open Lib

module M = Markup
module S = Soup

let emit_const x =
  let name = Option.get (S.attribute "name" x)
  and t = Option.get (S.attribute "type64" x)
  in
  if String.equal t "@" then
    Printf.printf "let %s = new_string \"%s\"\n"
      (if is_upper (String.get name 0) then "_" ^ name else name)
      name

let emit_enum x =
  let name = Option.get (S.attribute "name" x)
  and v = Option.get (S.attribute "value64" x)
  in
  Printf.printf "let %s = %s\n"
    (if is_upper (String.get name 0) then "_" ^ name else name)
    v

let func_type el =
  let arg_types =
    S.select "arg" el
    |> S.to_list
    |> List.map (fun arg ->
      try
        S.attribute "type64" arg
        |> Option.fold ~none:"?" ~some:Objc_t.Encode.enc_to_ctype_string
      with
      | Objc_t.Encode.Encode_struct arg ->
        begin match arg with
        | "NSRange.t" | "CGRect.t" | "CGPoint.t" | "CGSize.t" -> arg
        | _ -> "ptr void"
        end
      | Failure _ as e ->
        Printf.eprintf "Failed\n";
        raise e)
  and ret =
    try
      S.select_one "retval" el
      |> Option.get
      |> S.attribute "type64"
      |> Option.get
      |> Objc_t.Encode.enc_to_ctype_string
    with Objc_t.Encode.Encode_struct _ -> "ptr void"
  in
  begin match List.length arg_types with
  | 0 -> "void"
  | 1 -> List.hd arg_types
  | _ -> String.concat " @-> " arg_types
  end ^ " @-> returning (" ^ ret ^ ")"

let emit_func x =
  let name = Option.get (S.attribute "name" x)
  and ty = func_type x in
  Printf.printf "let %s = Foreign.foreign \"%s\" (%s)\n"
    (if is_upper (String.get name 0) then "_" ^ name else name)
    name ty

let emit x =
  match S.name x with
  | "constant" -> emit_const x
  | "enum" -> emit_enum x
  | "function" -> emit_func x
  | _ -> () (* Printf.eprintf "got %s\n" n *)

let main () =
  print_endline "(* auto-generated, do not modify *)\n";
  print_endline "open Runtime";
  print_endline "open Objc\n";

  M.channel stdin
  |> M.parse_xml
  |> M.signals
  |> S.from_signals
  |> S.select_one "signatures"
  |> Option.iter (fun x -> S.children x |> S.elements |> S.iter emit)

let () = main ()