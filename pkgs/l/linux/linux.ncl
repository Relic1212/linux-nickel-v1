{
  lib,
  pkgs,
  libModulesDirectory | lib.Package
    = {
      name = "lib-modules-directory",
      installPhase = [
        "install -d -m0755 ${DEST}/lib/modules/6.10.0-standard"
      ],
    },
  linux | lib.MakePackage
    = {
      name = "linux",
      sourceInputs = pkgs.linuxHeaders.sourceInputs,
      buildDir = "/tmp/workdir/src",
      buildEnv,
      makeArgs,
      extraFiles = [
        {
          file = "base.config",
          sha256sum = "fcd595d91c7a85c15530661e0b5d8a0dad1418fdc20a3f7de1044980b708d8aa"
        }
      ],

      extraEnv = {
        KBUILD_BUILD_TIMESTAMP = "''",
        HOSTLDFLAGS = "%{ lib.functions.varToExportvar (buildEnv.LDFLAGS @ ["-lz"] )}",
        HOSTCFLAGS = "%{ lib.functions.varToExportvar  buildEnv.CFLAGS}",
      },
      extraMakeArgs = [
        "LLVM=1",

        #    "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
        #  "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
      ],
      extraMakeInstallArgs = [
        "INSTALL_MOD_STRIP=1",
        "LLVM=1",
        "INSTALL_MOD_PATH=/tmp/workdir/out/destdir",
        "DEPMOD=true",
        # "DEPMOD=\"/usr/bin/depmod -b /tmp/workdir/out/destdir\"",
        # "MODLIB=${DEST}/usr/lib/modules/6.10.0-standard",
      ],
      makeInstallTargets = ["modules_install"],
      preBuildPhase = [
        "cp /tmp/workdir/files/base.config .config",
        "make "
        ++ (std.string.join " " makeArgs)
        ++ " HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} "
        ++ " HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS}"
        ++ " olddefconfig",

        # "mkdir /tmp/workdir/build/bin",
        # "cp /usr/bin/bsdtar /tmp/workdir/build/bin/tar",
        # "export PATH=/tmp/workdir/build/bin:${PATH}"
      ],
      postInstallPhase = [
        # "KVER=\"$(ls /tmp/workdir/out/destdir/lib/modules/)\"",
        # "depmod -b /tmp/workdir/out/destdir  ${KVER}",
        "install -d -m0755 ${DEST}/boot",
        "install -m0755 arch/x86/boot/bzImage  ${DEST}/boot",
      ],
      biPkgs = [
        pkgs.perl,
        pkgs.m4,
        pkgs.libtool,
        pkgs.openssl,
        pkgs.zlibNg,
        pkgs.xz,
        pkgs.flex,
        pkgs.bison,
        pkgs.linuxHeaders,
        pkgs.libelf,
        pkgs.diffutils,
        pkgs.zstd,
        pkgs.lz4,
        pkgs.kmod, #, libModulesDirectory,
        #, pkgs.libarchive,
      ],
    },
  linuxAarch64 =
    linux
    & {
      makeArgs,
        extraFiles|priority 1 = [
        {
          file = "kernel-aarch64-fedora.config",
          sha256sum = "99cc448445ba26180a412cfdd36348200b2f4635ce4631070a98505045c46aaf"
        }
      ],
      extraMakeArgs|priority 1=[
                  "ARCH=arm64",
                  "LLVM=1",
      ],
      buildEnv.TARGET="aarch64-unknown-linux-musl",
      buildEnv.EXTRA_LDFLAGS=["--verbose", " -nostdlib"],
      extraMakeInstallArgs | priority 1
        = [
          "INSTALL_MOD_STRIP=1",
          "LLVM=1",
          "INSTALL_MOD_PATH=/tmp/workdir/out/destdir",
          "ARCH=arm64"
          # "DEPMOD=\"/usr/bin/depmod -b /tmp/workdir/out/destdir\"",
          # "MODLIB=${DEST}/usr/lib/modules/6.10.0-standard",
        ],
         preBuildPhase|priority 1 = [
        "cp /tmp/workdir/files/kernel-aarch64-fedora.config .config",

# https://lists.freedesktop.org/archives/amd-gfx/2024-May/109223.html
        m%"sed -i 's@__counted_by(ucNumEntries)@@g' ./drivers/gpu/drm/radeon/pptable.h"%,
        "make "
        ++ (std.string.join " " makeArgs)
        ++ " HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.STATIC_LDFLAGS} "
        ++ " HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.STATIC_CFLAGS}"
        ++ " olddefconfig",

        # "mkdir /tmp/workdir/build/bin",
        # "cp /usr/bin/bsdtar /tmp/workdir/build/bin/tar",
        # "export PATH=/tmp/workdir/build/bin:${PATH}"
      ],
          extraEnv |force= {
        KBUILD_BUILD_TIMESTAMP = "''",
        HOSTLDFLAGS = "%{ lib.functions.varToExportvar (buildEnv.STATIC_LDFLAGS @ ["-lz"] )}",
        HOSTCFLAGS = "%{ lib.functions.varToExportvar  buildEnv.STATIC_CFLAGS}",
      },
        buildInputs|force =lib.biMap [
          pkgs.busybox,
          pkgs.gnumake,
          pkgs.ccacheBin,
           pkgs.clangCross,
          pkgs.muslAarch64,
          pkgs.musl,
          pkgs.libcxxAarch64,
          pkgs.compilerRtAarch64,
          pkgs.linuxHeadersAarch64,
          pkgs.linuxHeaders,

        pkgs.perl,
        pkgs.m4,
        pkgs.libtool,
        pkgs.openssl, # tgt?
        pkgs.zlibNg, # tgt?
        pkgs.xz,
        pkgs.flex,
        pkgs.bison,
        pkgs.libelf,
        pkgs.diffutils,
        pkgs.zstd,
        pkgs.lz4,
        pkgs.kmod, #, libModulesDirectory,
        #, pkgs.libarchive,
        pkgs.pythonFull,

      ],
    }
}
