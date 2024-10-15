let 
drvUtils=import "drv.ncl"
in

let 
musl = import "pkgs/musl/musl.ncl"
in 
drvUtils.pkgToJson musl