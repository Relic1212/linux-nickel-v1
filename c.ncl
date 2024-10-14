let
lib = import "lib.ncl"
in 
let 

pkgs={

helloMeson|lib.MesonPackage={name="hello-meson"},
helloAutotools|lib.AutotoolsPackage={name="hello-autotools",buildInputs|priority 2=[helloMeson]}

}
in 
pkgs