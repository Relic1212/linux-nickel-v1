let r = {
  __pkgs =
    (
      (import "lib.ncl")
      & (import "../pkgs/a/autoconf/autoconf.ncl")
      & (import "../pkgs/a/automake/automake.ncl")
      & (import "../pkgs/b/bash/bash.ncl")
      & (import "../pkgs/b/bison/bison.ncl")
      & (import "../pkgs/b/busybox/busybox-stage-0.ncl")
      & (import "../pkgs/b/busybox/busybox.ncl")
      & (import "../pkgs/c/ccache/ccache-bin.ncl")
      & (import "../pkgs/c/ccache/ccache.ncl")
      & (import "../pkgs/c/cmake/cmake-stage-1.ncl")
      & (import "../pkgs/c/cmake/cmake.ncl")
      & (import "../pkgs/f/flex/flex.ncl")
      & (import "../pkgs/g/gnumake/gnumake-stage-1.ncl")
      & (import "../pkgs/g/gnumake/gnumake.ncl")
      & (import "../pkgs/j/json-c/json-c.ncl")
      & (import "../pkgs/l/libffi/libffi.ncl")
      & (import "../pkgs/l/libssp-nonshared/libssp-nonshared-stage-0.ncl")
      & (import "../pkgs/l/libtool/libtool.ncl")
      & (import "../pkgs/l/linux-headers/linux-headers.ncl")
      & (import "../pkgs/l/llvm/llvm-baselibs-stage-0.ncl")
      & (import "../pkgs/l/llvm/llvm-stage-0.ncl")
      & (import "../pkgs/l/llvm/llvm.ncl")
      & (import "../pkgs/l/lvm2/lvm2.ncl")
      & (import "../pkgs/m/m4/m4.ncl")
      & (import "../pkgs/m/meson/meson.ncl")
      & (import "../pkgs/m/musl/musl.ncl")
      & (import "../pkgs/n/ninja/ninja-stage-1.ncl")
      & (import "../pkgs/o/openssl/openssl.ncl")
      & (import "../pkgs/p/perl/perl.ncl")
      & (import "../pkgs/p/pkgconf/pkgconf.ncl")
      & (import "../pkgs/p/python-packages/python-setuptools.ncl")
      & (import "../pkgs/p/python/python-full.ncl")
      & (import "../pkgs/p/python/python.ncl")
      & (import "../pkgs/s/samurai/samurai.ncl")
      & (import "../pkgs/u/util-linux/util-linux.ncl")
      & (import "../pkgs/z/zlib-ng/zlib-ng.ncl")
      & {}
    )
    & { pkgs = __pkgs },

  pkgs = (std.record.filter (fun f v => (std.string.substring 0 1 f != "_")) (std.record.remove "pkgs" (std.record.remove "lib" (__pkgs))))
}
in

r.pkgs
