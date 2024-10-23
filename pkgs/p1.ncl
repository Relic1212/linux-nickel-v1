let lib = import "../nickellib/lib.ncl"
in
let helloMeson | lib.MesonPackage
  = { name = "hello-meson" }
  in
helloMeson
