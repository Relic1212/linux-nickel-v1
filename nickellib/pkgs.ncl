let drvUtils = import "../nickellib/drv.ncl"
in

let _pkgsArray = [
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

  # {
  #     name=pkgsRecord."flex-stage-1".name ++ "-other"

  # }
]
in
let pkgs =
  std.record.merge_all (_pkgsArray)
in
let si_all =
  std.record.merge_all (
    std.array.map
      (fun si => { "%{si.src.sha256sum}" = std.serialize 'Json si.src })
      (std.array.flatten (std.record.values (std.record.map_values (fun p => p.sourceInputs) pkgs)))
  )
in

{
  drvByHash = (std.record.from_array (std.record.values (std.record.map_values (fun x => { field = "%{drvUtils.pkgToHash x}", value = drvUtils.pkgToJson x }) pkgs))) & si_all,

  hashByName = std.record.from_array (std.record.values (std.record.map_values (fun x => { field = x.name, value = drvUtils.pkgToHash x }) pkgs)),
}
# let m= std.array.flatten(std.record.values
# (std.record.map_values (fun x=> x.buildInputs ) pkgs))

# in
# std.array.map (drvUtils.pkgOrHashToHash) m
# (drvUtils.toDrvsByhashOnly) pkgs
