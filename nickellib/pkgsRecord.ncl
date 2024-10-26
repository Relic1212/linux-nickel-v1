let r = {
  __pkgs =
    (
      (import "lib.ncl")
      & (import "../pkgs/a/argp-standalone/argp-standalone.ncl")

      & (import "../pkgs/a/autoconf/autoconf.ncl")
      & (import "../pkgs/a/automake/automake.ncl")
      & (import "../pkgs/b/basefiles/basefiles.ncl")
      & (import "../pkgs/b/bash/bash.ncl")
      & (import "../pkgs/b/bison/bison.ncl")
      & (import "../pkgs/b/busybox/busybox-stage-0.ncl")
      & (import "../pkgs/b/busybox/busybox.ncl")
      & (import "../pkgs/c/ccache/ccache-bin.ncl")
      & (import "../pkgs/c/ccache/ccache.ncl")
      & (import "../pkgs/c/cmake/cmake-stage-1.ncl")
      & (import "../pkgs/c/cmake/cmake.ncl")
      & (import "../pkgs/c/cryptsetup/cryptsetup.ncl")

      & (import "../pkgs/d/dbus/dbus.ncl")

      & (import "../pkgs/d/diffutils/diffutils.ncl")

      & (import "../pkgs/d/dinit/dinit.ncl")
      & (import "../pkgs/d/dropbear/dropbear.ncl")

      & (import "../pkgs/e/erofs-utils/erofs-utils.ncl")
      & (import "../pkgs/e/eudev/eudev.ncl")


      & (import "../pkgs/e/expat/expat.ncl")

      & (import "../pkgs/f/flex/flex.ncl")
      & (import "../pkgs/f/file/file.ncl")

      & (import "../pkgs/f/findutils/findutils.ncl")
      & (import "../pkgs/g/git/git.ncl")

      & (import "../pkgs/g/gnumake/gnumake-stage-1.ncl")
      & (import "../pkgs/g/gnumake/gnumake.ncl")
      & (import "../pkgs/g/gperf/gperf.ncl")

      & (import "../pkgs/h/hwdata/hwdata.ncl")

      & (import "../pkgs/i/iwd/iwd.ncl")

      & (import "../pkgs/j/json-c/json-c.ncl")
      & (import "../pkgs/k/kmod/kmod.ncl")

      & (import "../pkgs/l/libarchive/libarchive.ncl")

      & (import "../pkgs/l/libbsd/libbsd.ncl")

      & (import "../pkgs/l/libmd/libmd.ncl")


      & (import "../pkgs/l/libelf/libelf.ncl")

      & (import "../pkgs/l/libffi/libffi.ncl")
      & (import "../pkgs/l/libssp-nonshared/libssp-nonshared-stage-0.ncl")
      & (import "../pkgs/l/libtool/libtool.ncl")
      & (import "../pkgs/l/linux-headers/linux-headers.ncl")
      & (import "../pkgs/l/linux/linux.ncl")

      & (import "../pkgs/l/libpciaccess/libpciaccess.ncl")
      & (import "../pkgs/l/libdrm/libdrm.ncl")


      & (import "../pkgs/l/llvm/llvm-baselibs-stage-0.ncl")
      & (import "../pkgs/l/llvm/llvm-stage-0.ncl")
      & (import "../pkgs/l/llvm/llvm.ncl")
      & (import "../pkgs/l/lvm2/lvm2.ncl")
      & (import "../pkgs/l/lz4/lz4.ncl")

      & (import "../pkgs/m/m4/m4.ncl")
      & (import "../pkgs/m/mesa/mesa.ncl")

      & (import "../pkgs/m/meson/meson.ncl")
      & (import "../pkgs/m/musl/musl.ncl")
      & (import "../pkgs/m/musl-fts/musl-fts.ncl")
      & (import "../pkgs/m/musl-obstack/musl-obstack.ncl")

      & (import "../pkgs/m/mtdev/mtdev.ncl")

      & (import "../pkgs/m/mtools/mtools.ncl")

      & (import "../pkgs/n/ncurses/ncurses.ncl")

      & (import "../pkgs/n/ninja/ninja-stage-1.ncl")
      & (import "../pkgs/o/openssl/openssl.ncl")
      & (import "../pkgs/p/perl/perl.ncl")
      & (import "../pkgs/p/popt/popt.ncl")

      & (import "../pkgs/p/pkgconf/pkgconf.ncl")
      & (import "../pkgs/p/python-packages/python-flit-core.ncl")
      & (import "../pkgs/p/python-packages/python-gpep517.ncl")


      & (import "../pkgs/p/python-packages/python-installer.ncl")
      & (import "../pkgs/p/python-packages/python-mako.ncl")

      & (import "../pkgs/p/python-packages/python-markupsafe.ncl")
      & (import "../pkgs/p/python-packages/python-packaging.ncl")



      & (import "../pkgs/p/python-packages/python-setuptools.ncl")
      & (import "../pkgs/p/python/python-full.ncl")
      & (import "../pkgs/p/python/python.ncl")
      & (import "../pkgs/r/readline/readline.ncl")
      & (import "../pkgs/s/samurai/samurai.ncl")
      & (import "../pkgs/s/seatd/seatd.ncl")
      & (import "../pkgs/s/shadow/shadow.ncl")

      & (import "../pkgs/u/util-linux/util-linux.ncl")
      & (import "../pkgs/u/unzip/unzip.ncl")

      & (import "../pkgs/w/wayland/wayland.ncl")
      & (import "../pkgs/w/wayland-protocols/wayland-protocols.ncl")



      & (import "../pkgs/x/xz/xz.ncl")

      & (import "../pkgs/z/zlib-ng/zlib-ng.ncl")
      & (import "../pkgs/z/zstd/zstd.ncl")

      & {}
    )
    & { pkgs = __pkgs },

  pkgs = (std.record.filter (fun f v => (std.string.substring 0 1 f != "_")) (std.record.remove "pkgs" (std.record.remove "lib" (__pkgs))))
}
in

r.pkgs
