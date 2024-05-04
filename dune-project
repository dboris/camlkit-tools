(lang dune 3.13)

(name camlkit-tools)
(version 0.1.1)

(generate_opam_files true)

(source (github dboris/camlkit-tools))

(authors "Boris D. <borisd@gmx.com>")
(maintainers "Boris D. <borisd@gmx.com>")
(license ISC)

(package
 (name camlkit-tools)
 (synopsis "Tools for introspecting the Objective-C runtime and generating OCaml bindings")
 (description "Tools for introspecting the Objective-C runtime and generating OCaml bindings")
 (depends
  ocaml
  dune
  ctypes
  ctypes-foreign
  camlkit-base
  markup
  lambdasoup)
 (tags (camlkit objc bindings cocoa gnustep)))