
let _pkgsArray = [
  # {  import "lib.ncl" },
  # {pkgs|default=null},
   import "lib2.ncl"  ,
  import "../pkgs/musl/musl-stage-0.ncl",
  import "../pkgs/musl/musl.ncl",
  import "../pkgs/llvm/llvm-stage-0.ncl",
  import "../pkgs/llvm/llvm-baselibs-stage-0.ncl",
  import "../pkgs/linux-headers/linux-headers-stage-0.ncl",
  import "../pkgs/linux-headers/linux-headers.ncl",
  import "../pkgs/libssp-nonshared/libssp-nonshared-stage-0.ncl",
  import "../pkgs/busybox/busybox-stage-0.ncl",
  import "../pkgs/busybox/busybox-stage-1.ncl",
  import "../pkgs/gnumake/gnumake-stage-1.ncl",
  import "../pkgs/gnumake/gnumake.ncl",
  import "../pkgs/ccache/ccache-bin.ncl",
  import "../pkgs/python/python.ncl",
  import "../pkgs/cmake/cmake-stage-1.ncl",
  import "../pkgs/cmake/cmake.ncl",
  import "../pkgs/m4/m4.ncl",
  import "../pkgs/flex/flex.ncl",
  import "../pkgs/bison/bison.ncl",
  import "../pkgs/llvm/llvm-stage-1.ncl",
  import "../pkgs/ninja/ninja-stage-1.ncl",
  import "../pkgs/samurai/samurai.ncl",
  import "../pkgs/bash/bash.ncl",
  import "../pkgs/perl/perl.ncl",
  import "../pkgs/autoconf/autoconf.ncl",
  import "../pkgs/automake/automake.ncl",
  import "../pkgs/util-linux/util-linux.ncl",
  import "../pkgs/libtool/libtool.ncl",
  import "../pkgs/python-packages/python-setuptools.ncl",
  import "../pkgs/openssl/openssl.ncl",
  import "../pkgs/pkgconf/pkgconf.ncl",
  import "../pkgs/zlib-ng/zlib-ng.ncl",
  import "../pkgs/python/python-full.ncl",
  import "../pkgs/libffi/libffi.ncl",
  import "../pkgs/meson/meson.ncl",
  import "../pkgs/lvm2/lvm2.ncl",
  import "../pkgs/json-c/json-c.ncl",
  import "../pkgs/ccache/ccache.ncl",




  # {
  #     name=pkgsRecord."flex-stage-1".name ++ "-other"

  # }
]
in
let 
  __pkgs =  (std.record.merge_all ( _pkgsArray))
in
let 
_pkgs=__pkgs&{pkgs=__pkgs}
in
let
 
  pkgs = std.record.remove "pkgs"  (std.record.remove "lib" (_pkgs))
  
in
pkgs