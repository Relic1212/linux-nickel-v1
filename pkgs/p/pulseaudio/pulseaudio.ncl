
{
    lib, drvs,
    tdb  | lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://www.samba.org/ftp/tdb/tdb-1.4.13.tar.gz",
            sha256sum = "5ee276e7644d713e19e4b6adc00b440afb5851ff21e65821ffaed89e15a5e167"
        },
        extraEnv = {
        #HOST_CC = [ "clang", "-static"]
      },
      biDrvs  = [
        drvs.pythonDynamic,
        drvs.muslShared,
      ],
    #   extraMakeArgs = [
    #     "HOST_CC='clang -static --static'",
    #     "HOST_CXX='clang++ -static --static'",
    #   ],
      separateBuildDir = false,

      configureFlags | force = [
        "--prefix=/usr",
        # "--exec_prefix=/usr",
        "--bindir=/usr/bin",
        "--sbindir=/usr/bin",
        "--libexecdir=/usr/libexec",
        "--datadir=/usr/share",
        "--sysconfdir=/etc",
        "--sharedstatedir=/com",
        "--localstatedir=/var",
        "--libdir=/usr/lib",
        "--includedir=/usr/include",
        "--oldincludedir=/usr/include",
        "--infodir=/usr/share/info",
        "--mandir=/usr/share/man",
        # "--enable-static",
        # "--disable-shared"
      ]
    }
}


&
{
    lib,
    drvs,
    pulseaudio14|lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://freedesktop.org/software/pulseaudio/releases/pulseaudio-14.2.tar.gz",
            sha256sum = "902dd1928801bb5dc7b121754aa4110ce55768b5dff94a700e7bd58d3f597970"
        },

        #llvmProvider = drvs.llvmFull,
        biDrvs=[
            drvs.libsndfile,
               drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.glibDynamic,
        drvs.muslShared,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.libepoxy,
        drvs.atSpi2Core,
        #drvs.mesa2,
        #drvs.libelf,
        #drvs.libdrm,
        #drvs.libpciaccess,
        #drvs.llvmConfigStatic,
        #drvs.spirvTools,
        #drvs.spirvLlvmTranslator,

        #drvs."gtk+3",

        drvs.libtool,
        drvs.perl,
        drvs.m4,
        drvs.dbus,

        drvs.libcap,
        drvs.eudev,

          drvs.kmod,
          drvs.xz,
          drvs.openssl,
          drvs.zstd,
          drvs.utilLinux,

          drvs.pkgconf,

                  drvs.alsaLibs,

        drvs.bluez,
        drvs.sbc,

        drvs.ffmpeg,
        drvs.speex,
        drvs.speexdsp,
        ],

        preConfigurePhase = [
            "sed -i 's@main ()@main (void)@g' ${SRC}/configure",

            "sed -i 's@#include <gdk/gdkx.h>@@g' ${SRC}/src/pulsecore/proplist-util.c",

          #  "sed -i 's@#ifdef DISABLE_LIBTOOL_PRELOAD@#if 1@g' ${SRC}/src/daemon/main.c",

          "sed -i 's@#ifdef PA_BIND_NOW@#if 0@g' ${SRC}/src/daemon/ltdl-bind-now.c",
        ],
        extraConfigureFlags = [
            "--enable-static-bins",
             "--enable-force-preopen",
            "--disable-gtk3",
            "--enable-bluez5",

            "--with-speex",

           "ac_cv_func_dlopen='no'"
        ],
        postInstallPhase = [
            "cd ${DEST}/usr/lib/pulse-14.2/modules/",
            m%"
            for f in $(ls); do
                new_name=$(echo ${f} | cut -d '.' -f1)
                new_name="${new_name}.so"
                ln -s ${f} ${new_name}
            done
            "%
        ]


    }
}

&

{
    lib,
    drvs,
    speex | lib.AutotoolsPackage = {
        singleSource = {
            uri = "http://downloads.xiph.org/releases/speex/speex-1.2.1.tar.gz",
            sha256sum = "4b44d4f2b38a370a2d98a78329fefc56a0cf93d1c1be70029217baae6628feea"
        }
    }
}


&

{
    lib,
    drvs,
    speexdsp | lib.AutotoolsPackage = {
        singleSource = {
            uri = "http://downloads.xiph.org/releases/speex/speexdsp-1.2.1.tar.gz",
            sha256sum = "8c777343e4a6399569c72abc38a95b24db56882c83dbdb6c6424a5f4aeb54d3d"
        }
    }
}

&

{
    lib,
    drvs,
    pulseaudio14,
    pulseaudio8 | lib.AutotoolsPackage = (pulseaudio14 & {
        singleSource | priority 200 = {
            uri = "https://freedesktop.org/software/pulseaudio/releases/polypaudio-0.8.1.tar.gz",
            sha256sum = "6425fc9bc3a260b20506ae3e7397308af963f547f1a09b4dd85e1b2525b674e9"
        },
        preConfigurePhase | priority 1 = [

        ],
        biDrvs | priority 1 = pulseaudio14.biDrvs @ [
            drvs.libsamplerate,
            drvs.liboil,
            ],
        extraConfigureFlags|priority 1 = [
   "--enable-static-bins",
             "--enable-force-preopen",
            "--disable-gtk3",
            "--enable-bluez5",

            "--with-speex",

           "ac_cv_func_dlopen='no'",
            "ac_cv_func_memcpy='no'",
        ]
    })
}

& 

{
    lib,
    drvs,
    libsamplerate | lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://github.com/libsndfile/libsamplerate/releases/download/0.2.2/libsamplerate-0.2.2.tar.xz",
            sha256sum = "3258da280511d24b49d6b08615bbe824d0cacc9842b0e4caf11c52cf2b043893"
        }
    }
}

&

{
    lib,
    drvs,
    liboil | lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz",
            sha256sum = "105f02079b0b50034c759db34b473ecb5704ffa20a5486b60a8b7698128bfc69"
        },
        buildEnv = {
            EXTRA_CFLAGS = [
                "-fheinous-gnu-extensions",
            ]
        }
    }
}