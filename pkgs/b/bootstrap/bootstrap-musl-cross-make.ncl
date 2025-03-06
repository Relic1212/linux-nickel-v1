{
  lib,
  muslCrossMakeStage0 | lib.MakePackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/richfelker/musl-cross-make/archive/refs/tags/v0.9.10.tar.gz",

          sha256sum = "4fe9d3bef9d624c5c25187b7ac80d5fef67edfd2ec4a526da3c0c4ed6df072ac",
        }
      },
      {
        src = {
          # uri = "https://ftpmirror.gnu.org/gnu/gcc/gcc-9.4.0/gcc-9.4.0.tar.xz",
          uri = "https://ftp.gnu.org/gnu/gcc/gcc-9.4.0/gcc-9.4.0.tar.xz",
          sha256sum = "c95da32f440378d7751dd95533186f7fc05ceb4fb65eb5b85234e6299eb9838e",
        }
      },
      {
        src = {
          uri = "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=3d5db9ebe860",
          sha256sum = "75d5d255a2a273b6e651f82eecfabf6cbcd8eaeae70e86b417384c8f4a58d8d3"
        }
      },
      {
        src = {
          uri = "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.33.1.tar.xz",
          sha256sum = "ab66fc2d1c3ec0359b8e08843c9f33b63e8707efdff5e4cc5c200eae24722cbf",
        }
      },
      {
        src = {
          uri = "https://musl.libc.org/releases/musl-1.2.4.tar.gz",
          sha256sum = "7a35eae33d5372a7c0da1188de798726f68825513b7ae3ebe97aaaa52114f039"
        }
      },
      {
        src = {
          uri = "https://ftpmirror.gnu.org/gnu/gmp/gmp-6.1.2.tar.bz2",
          sha256sum = "5275bb04f4863a13516b2f39392ac5e272f5e1bb8057b18aec1c9b79d73d8fb2",
        }
      },
      {
        src = {
          uri = "https://ftpmirror.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz",
          sha256sum = "6985c538143c1208dcb1ac42cedad6ff52e267b47e5f970183a3e75125b43c2e"
        }
      },
      {
        src = {
          uri = "https://ftpmirror.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.bz2",
          sha256sum = "c05e3f02d09e0e9019384cdd58e0f19c64e6db1fd6f5ecf77b4b1c61ca253acc"
        }
      },
      {
        src = {
          uri = "http://ftp.barfooze.de/pub/sabotage/tarballs//linux-headers-4.19.88-1.tar.xz",
          sha256sum = "995bc76ccf0c40d752b5ea67c022232a17eef6c9ec80ea74ea742e3c19992813"
        }
      }
    ],
    stage = 0,
    makeArgs = [
      "TARGET=x86_64-linux-musl",
      "-j$(nproc)",
    ],
    extraMakeInstallArgs = [
      "TARGET=x86_64-linux-musl",
      "OUTPUT=/",
    ],
    isLlvm | force = false,
    isStatic | force = false,
    buildEnv._isStatic | force = false,
    buildEnv._isLlvm | force = false,

    # buildEnv|force=std.record.map (fun k v => if (k)  null ) lib.MakePackage.buildEnv,

    unpackPhase =
      let h = (std.array.at 0 sourceInputs).src.sha256sum in
      [
        lib.shellFunctions.unpackMaybe,
        "mkdir -p /tmp/workdir/src/",
        "unpack_maybe /tmp/workdir/packed/%{h}/ /tmp/workdir/src/",
        "touch /tmp/resolv.conf",
        "mount --bind /tmp/resolv.conf /etc/resolv.conf",
      ],
    preConfigurePhase = [
      "rm -rf patches/*",
      "mkdir sources",
      "cp /tmp/workdir/packed/*/* sources/",
      "mv sources/\"?p=config.git;a=blob_plain;f=config.sub;hb=3d5db9ebe860\" sources/config.sub",
      m%"sed -i 's@xvf -@xf - --no-same-owner@g' Makefile"%,
      m%"sed -i 's@MAKEINFO=false@MAKEINFO=true@g' litecross/Makefile"%,
      m%"
            echo """
            COMMON_CONFIG +=  LDFLAGS=\"-static --static\"
            COMMON_CONFIG += --disable-nls --enable-static --disable-shared
            GCC_CONFIG += --disable-libquadmath --disable-decimal-float
            GCC_CONFIG += --disable-libitm
            GCC_CONFIG += --disable-fixed-point
            GCC_CONFIG += --disable-lto
            GCC_CONFIG += --disable-libada --disable-libgm2 --disable-libsanitizer --disable-analyzer --disable-gcov --disable-libatomic --disable-libgomp --disable-libvtv

            """ >>  config.mak
            "%,
    ],
    preInstallPhase = [
      m%"
            if [ ! $(command -v cmp) ]; then
                install -d -m0755 /tmp/workdir/build/bin

                echo "#!/bin/sh" > /tmp/workdir/build/bin/cmp
                echo "true" >> /tmp/workdir/build/bin/cmp

                chmod +x /tmp/workdir/build/bin/cmp
                export PATH="${PATH}:/tmp/workdir/build/bin"
            fi

            "%
    ]
  }
}
