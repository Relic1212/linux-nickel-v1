{
  lib,
  drvs,
  sway | lib.MesonPackage = {
    name = "sway",

    sourceInputs = [
      {
        src = {
          # uri = "https://github.com/swaywm/sway/archive/015e357fce8250cdde03844ca81e9ae982ef4bfb.zip",
          # sha256sum = "449a213107680cc234c093e3a21247406bac3fa6e1c9c345a3a9854bd804844c",

          #uri = "https://github.com/swaywm/sway/archive/962e1e70a60e9f39d2fdb6fa1810017682fd1f7b.zip",
          #sha256sum = "a1fcf4b802cc1a14b1627fc35cbe281284fadbdf99dc24473e4f1927879badfa",

          # uri="https://github.com/swaywm/sway/releases/download/1.10.1/sway-1.10.1.tar.gz",
          # sha256sum = "b2fbf3a2f94c8926efa18d6af59bb9f5f1eafa6d46491284b1610c57bef2d105"

          uri = "https://github.com/swaywm/sway/releases/download/1.11/sway-1.11.tar.gz",
          sha256sum = "0e37a55b7c3379230e97e1ad982542b75016a0c7d6676198604e557f9b373dae"
        }
      },
      {
        src = {
          #uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/a9542b9565260a84c148f277fd9d6a0548405489/wlroots-a9542b9565260a84c148f277fd9d6a0548405489.tar.gz",
          #sha256sum = "210c49a37ef5c9f771f0dc334cde682d7339e2679011b9c7fbf494c32e1c6dd1"

          # uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.18.2/downloads/wlroots-0.18.2.tar.gz",
          # sha256sum = "cf776c169169f279808d9eabc6583f484338dcd454c966a285ff178c88c105d4",

          uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.19.0/downloads/wlroots-0.19.0.tar.gz",
          sha256sum = "aefb0fe2633b0aad1d66123b2f41afab004fb625e2a7790492cdd39a805cac91",
        },
        dest = "wlroots"
      }
    ],
    buildEnv.EXTRA_LDFLAGS = ["-lc++"],
    # baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,

    extraMesonArgs = [
      "-Dwlroots:backends=drm,libinput",
      "-Dwlroots:color-management=enabled",
      "-Dwlroots:renderers=gles2",
      "-Dgdk-pixbuf=enabled",
      "-Dtray=enabled",
      "-Dman-pages=enabled",
    ],

    preConfigurePhase = [
      m%"
            fix_symbol(){
                echo    sed -i "s@${1}(@${1}_sway(@g"
                for f in $(find ${SRC} -type f -name '*.h' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_sway(@g" $f
                    sed -i "s@_${1}_sway(@_${1}(@g" $f
                done
                for f in $(find ${SRC} -type f -name '*.c' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_sway(@g" $f
                    sed -i "s@_${1}_sway(@_${1}(@g" $f
                done
            }
            "%,
      "fix_symbol \"list_insert\"",
      "fix_symbol \"parse_boolean\"",
      "mkdir -p ${SRC}/subprojects",
      "mv ${SRC}/wlroots ${SRC}/subprojects",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.spirvTools,
      drvs.wayland,
      #drvs.waylandProtocols_1_41,
      drvs.waylandProtocols,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libxkbcommon,
      drvs.pixman,
      drvs.eudev,
      # drvs.libudevZero,
      drvs.seatd,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,

      # For optional features
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,
    ]
  }
}
& {
  lib,
  drvs,
  sway,
  swayX11 | lib.MesonPackage =
    sway
    & {
      biDrvs | priority 1 =
        sway.biDrvs
        @ [
          drvs.libxcursor,
          drvs.xorgMacros,
          drvs.xorgproto,
          drvs.xtrans,
          drvs.libxcb,
          drvs.xcbProto,
          drvs.libxau,
          drvs.libx11,
          drvs.libxrender,
          drvs.libxfixes,
          drvs.xcbRenderutil,
          drvs.libxfont2,
          drvs.libfontenc,
          drvs.libxcvt,
          drvs.libxshmfence,
          drvs.xwayland,
          drvs.libxkbfile,
          drvs.openssl,
          drvs.xcbUtilWm,
        ],

      extraMesonArgs | priority 1 = [
        "-Dwlroots:backends=drm,libinput,x11",
        "-Dwlroots:xwayland=enabled",
        "-Dwlroots:color-management=enabled",
        "-Dgdk-pixbuf=enabled",
        "-Dtray=enabled",
        "-Dman-pages=enabled",
      ],
    }
}
& {
  lib,
  drvs,
  xcbRenderutil | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.10.tar.xz",
      sha256sum = "3e15d4f0e22d8ddbfbb9f5d77db43eacd7a304029bf25a6166cc63caa96d04ba"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.pkgconf,
    ]
  }
}
& {
  lib,
  drvs,
  libxfont2 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/lib/libXfont2-2.0.7.tar.xz",
      sha256sum = "8b7b82fdeba48769b69433e8e3fbb984a5f6bf368b0d5f47abeec49de3e58efb"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.pkgconf,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.libfontenc,
    ]
  }
}
& {
  lib,
  drvs,
  libxkbfile | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/lib/libxkbfile-1.1.3.tar.xz",
      sha256sum = "a9b63eea997abb9ee6a8b4fbb515831c841f471af845a09de443b28003874bec"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.pkgconf,
    ]
  }
}
& {
  lib,
  drvs,
  libfontenc | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/releases/individual/lib/libfontenc-1.1.8.tar.xz",
      sha256sum = "7b02c3d405236e0d86806b1de9d6868fe60c313628b38350b032914aa4fd14c6"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.pkgconf,
      drvs.zlibNg,
      drvs.xcbRenderutil,
    ]
  }
}
& {
  lib,
  drvs,
  xcbUtilWm | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xcb.freedesktop.org/dist/xcb-util-wm-0.4.2.tar.xz",
      sha256sum = "62c34e21d06264687faea7edbf63632c9f04d55e72114aa4a57bb95e4f888a0b"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.pkgconf,
      drvs.zlibNg,
      drvs.xcbRenderutil,
      drvs.m4,
    ]
  }
}
& {
  lib,
  drvs,
  libxshmfence | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/lib/libxshmfence-1.3.2.tar.xz",
      sha256sum = "870df257bc40b126d91b5a8f1da6ca8a524555268c50b59c0acd1a27f361606f"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.pkgconf,
      drvs.zlibNg,
      drvs.xcbRenderutil,
    ]
  }
}
& {
  lib,
  drvs,
  xkbcomp | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/app/xkbcomp-1.4.7.tar.xz",
      sha256sum = "0a288114e5f44e31987042c79aecff1ffad53a8154b8ec971c24a69a80f81f77"
    },
    buildEnv = {
      EXTRA_LDFLAGS = ["-l:libxcb.a", "-l:libXau.a"]
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.pkgconf,
      drvs.zlibNg,
      drvs.xcbRenderutil,
      drvs.libxkbfile,
      drvs.libxkbcommon,
    ]
  }
}
& {
  lib,
  drvs,
  libxcvt | lib.MesonPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/lib/libxcvt-0.1.2.tar.xz",
      sha256sum = "0561690544796e25cfbd71806ba1b0d797ffe464e9796411123e79450f71db38"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.zlibNg,
      drvs.xcbRenderutil,
    ],
    preConfigurePhase = [
      m%"sed -i 's@shared_library@library@g' ${SRC}/lib/meson.build"%
    ]
  }
}
& {
  lib,
  drvs,
  xwayland | lib.MesonPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/xserver/xwayland-24.1.4.tar.xz",
      sha256sum = "d96a78dbab819f55750173444444995b5031ebdcc15b77afebbd8dbc02af34f4"
    },
    biDrvs = [
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.libxkbcommon,
      drvs.libxkbfile,
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libdrm,
      drvs.pixman,
      drvs.libffi,
      drvs.libxfont2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.libfontenc,
      drvs.libxcvt,
      drvs.libxshmfence,
      drvs.libepoxy,
      drvs.openssl,
      drvs.linuxHeaders,
    ],
    extraMesonArgs = [
      "-Dxvfb=false",
      "-Dglx=false",
      "-Dxdmcp=false",
      "-Dxdm-auth-1=false",
      "-Dsecure-rpc=false",
      "-Dxres=false",
      # "-Dxace=false",
      "-Dxinerama=false",
      "-Dxv=false",
      "-Dglamor=false",
    ]
  }
}
