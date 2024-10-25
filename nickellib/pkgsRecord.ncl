
let 

r={
 __pkgs=(
   (import "lib.ncl"  )&
  (import "../pkgs/musl/musl.ncl")&
  (import "../pkgs/llvm/llvm-stage-0.ncl")&
  (import "../pkgs/llvm/llvm-baselibs-stage-0.ncl")&
  (import "../pkgs/linux-headers/linux-headers.ncl")&
  (import "../pkgs/libssp-nonshared/libssp-nonshared-stage-0.ncl")&
  (import "../pkgs/busybox/busybox-stage-0.ncl")&
  (import "../pkgs/busybox/busybox.ncl")&
  (import "../pkgs/gnumake/gnumake-stage-1.ncl")&
  (import "../pkgs/gnumake/gnumake.ncl")&
  (import "../pkgs/ccache/ccache-bin.ncl")&
  (import "../pkgs/python/python.ncl")&
  (import "../pkgs/cmake/cmake-stage-1.ncl")&
  (import "../pkgs/cmake/cmake.ncl")&
  (import "../pkgs/m4/m4.ncl")&
  (import "../pkgs/flex/flex.ncl")&
  (import "../pkgs/bison/bison.ncl")&
  (import "../pkgs/llvm/llvm.ncl")&
  (import "../pkgs/ninja/ninja-stage-1.ncl")&
  (import "../pkgs/samurai/samurai.ncl")&
  (import "../pkgs/bash/bash.ncl")&
  (import "../pkgs/perl/perl.ncl")&
  (import "../pkgs/autoconf/autoconf.ncl")&
  (import "../pkgs/automake/automake.ncl")&
  (import "../pkgs/util-linux/util-linux.ncl")&
  (import "../pkgs/libtool/libtool.ncl")&
  (import "../pkgs/python-packages/python-setuptools.ncl")&
  (import "../pkgs/openssl/openssl.ncl")&
  (import "../pkgs/pkgconf/pkgconf.ncl")&
  (import "../pkgs/zlib-ng/zlib-ng.ncl")&
  (import "../pkgs/python/python-full.ncl")&
  (import "../pkgs/libffi/libffi.ncl")&
  (import "../pkgs/meson/meson.ncl")&
  (import "../pkgs/lvm2/lvm2.ncl")&
  (import "../pkgs/json-c/json-c.ncl")&
  (import "../pkgs/ccache/ccache.ncl")


 )&{pkgs=__pkgs},


  pkgs = (std.record.filter ( fun f v => (  std.string.substring 0 1 f != "_" )) (std.record.remove "pkgs"  (std.record.remove "lib" (__pkgs))) )
}
in
 


r.pkgs 