let
lib = import "lib.ncl"
in 
let 
drvUtils =import "drv.ncl"
in
let 

pkgs={

helloMeson|lib.MesonPackage={name="hello-meson"},
helloMesonExt=helloMeson & {name|priority 1="hello-meson-ext",mesonArgs = (std.array.concat helloMeson.mesonArgs  ["-Dtests=false"])},

helloAutotools|lib.AutotoolsPackage={name="hello-autotools",buildInputs|priority 2=[helloMeson]}

}
in
let 
_j = drvUtils.pkgToJson pkgs.helloAutotools

in 
pkgs & { z={j=_j , h=drvUtils.pkgToHash pkgs.helloAutotools}}