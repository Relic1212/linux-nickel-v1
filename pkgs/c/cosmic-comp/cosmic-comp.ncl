{
  lib,
  drvs,
  cosmicComp | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/pop-os/cosmic-comp/archive/refs/tags/epoch-1.0.0-alpha.7.tar.gz",
      sha256sum = "7bd9f19a69fb9708448d0a551d2c8bf5abf809457694f17aefd8d4d03b70d16d"
    },

    nonCrateSourceInputs = [{ src = singleSource }] @ (import "source.ncl"),

    crates = (lib.functions.filterCrates (import "cosmic-comp-crates.json")),

    configurePhase = [
      "mv ${SRC}/vendor-taffy ${SRC}/vendor/taffy",
      "mv ${SRC}/vendor-id-tree ${SRC}/vendor/id-tree",
      "mv ${SRC}/vendor-smithay-egui ${SRC}/vendor/smithay-egui",
      "mv ${SRC}/vendor-rust-atomicwrites ${SRC}/vendor/rust-atomicwrites",
      "mv ${SRC}/vendor-cosmic-protocols ${SRC}/vendor/cosmic-protocols",
      "mv ${SRC}/vendor-cosmic-settings-daemon ${SRC}/vendor/cosmic-settings-daemon",
      "mv ${SRC}/vendor-cosmic-text ${SRC}/vendor/cosmic-text",
      "mv ${SRC}/vendor-freedesktop-icons ${SRC}/vendor/freedesktop-icons",
      "mv ${SRC}/vendor-glyphon ${SRC}/vendor/glyphon",
      "mv ${SRC}/vendor-libcosmic ${SRC}/vendor/libcosmic",
      "mv ${SRC}/vendor-smithay-clipboard ${SRC}/vendor/smithay-clipboard",
      "mv ${SRC}/vendor-softbuffer ${SRC}/vendor/softbuffer",
      "mv ${SRC}/vendor-window_clipboard ${SRC}/vendor/window_clipboard",
      "mv ${SRC}/vendor-smithay ${SRC}/vendor/smithay",

# https://github.com/Drakulix/id-tree.git?branch=feature%2Fcopy_clone#632a57d6
        # m%"
        # echo '
        # [source.crates-io]
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/DioxusLabs/taffy?rev=7781c70#7781c70241f7f572130c13106f2a869a9cf80885"]
        # git = "https://github.com/DioxusLabs/taffy"
        # rev = "7781c70"
        # replace-with = "vendored-sources"

        # [source."https://github.com/Drakulix/id-tree.git?branch=feature%2Fcopy_clone#632a57d6"]
        # git = "https://github.com/Drakulix/id-tree.git"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/Smithay/smithay-egui.git?rev=e720136#e7201366b88e4fb20d0c6618a6cac9acc6299e07"]
        # git = "https://github.com/Smithay/smithay-egui.git"
        # rev = "e720136"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/jackpot51/rust-atomicwrites#043ab4859d53ffd3d55334685303d8df39c9f768"]
        # git = "https://github.com/jackpot51/rust-atomicwrites"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os//cosmic-protocols?branch=main#bc4af918"]
        # git = "https://github.com/pop-os//cosmic-protocols"
        # replace-with = "vendored-sources"

        # [source."https://github.com/pop-os//cosmic-protocols?branch=main#bc4af918"]
        # git = "https://github.com/pop-os//cosmic-protocols"
        # branch = "main"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/cosmic-settings-daemon#e2aa1056900d6f8c9c7555c0401aa7c99281eb06"]
        # git = "https://github.com/pop-os/cosmic-settings-daemon"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/cosmic-text.git#9125dd48b771e9aa7833d106a9850e935f71eaa6"]
        # git = "https://github.com/pop-os/cosmic-text.git"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/freedesktop-icons#bfc22d531596b57646dc47bcd70b2eb6f3152cd4"]
        # git = "https://github.com/pop-os/freedesktop-icons" 
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/glyphon.git?tag=iced-0.14-dev#6ef9d12a20cfd0f7bdf38136a26ded9f7459ec8b"]
        # git = "https://github.com/pop-os/glyphon.git"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/libcosmic/#8a0e74b189f53dae9b8001c6fa5cf1820b3ececb"]
        # git = "https://github.com/pop-os/libcosmic/"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/smithay-clipboard?tag=pop-dnd-5#5a3007def49eb678d1144850c9ee04b80707c56a"]
        # git = "https://github.com/pop-os/smithay-clipboard"
        # tag = "pop-dnd-5"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/softbuffer?tag=cosmic-4.0#6e75b1ad7e98397d37cb187886d05969bc480995"]
        # git = "https://github.com/pop-os/softbuffer"
        # replace-with = "vendored-sources"

        # [source."git+https://github.com/pop-os/window_clipboard.git?tag=pop-0.13-2#6b9faab87bea9cebec6ae036906fd67fed254f5f"]
        # git = "https://github.com/hecrj/window_clipboard"
        # replace-with = "vendored-sources"
        
        # [source."git+https://github.com/smithay/smithay//?rev=ce61c9b#ce61c9b3293b13adf03863848426f0d7c4907c3e"]
        # git = "https://github.com/smithay/smithay//"
        # rev = "ce61c9b" 
        # replace-with = "vendored-sources"

        # [source.vendored-sources]
        # directory = "vendor"
        # ' > ${SRC}/.cargo/config.toml
        # "%,

        m%"
        echo '
        [source.crates-io]
replace-with = "vendored-sources"

[source."git+https://github.com/DioxusLabs/taffy?rev=7781c70"]
git = "https://github.com/DioxusLabs/taffy"
rev = "7781c70"
replace-with = "vendored-sources"

[source."git+https://github.com/Drakulix/id-tree.git?branch=feature/copy_clone"]
git = "https://github.com/Drakulix/id-tree.git"
branch = "feature/copy_clone"
replace-with = "vendored-sources"

[source."git+https://github.com/Smithay/smithay-egui.git?rev=e720136"]
git = "https://github.com/Smithay/smithay-egui.git"
rev = "e720136"
replace-with = "vendored-sources"

[source."git+https://github.com/jackpot51/rust-atomicwrites"]
git = "https://github.com/jackpot51/rust-atomicwrites"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os//cosmic-protocols?branch=main"]
git = "https://github.com/pop-os//cosmic-protocols"
branch = "main"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/cosmic-settings-daemon"]
git = "https://github.com/pop-os/cosmic-settings-daemon"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/cosmic-text.git"]
git = "https://github.com/pop-os/cosmic-text.git"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/freedesktop-icons"]
git = "https://github.com/pop-os/freedesktop-icons"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/glyphon.git?tag=iced-0.14-dev"]
git = "https://github.com/pop-os/glyphon.git"
tag = "iced-0.14-dev"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/libcosmic/"]
git = "https://github.com/pop-os/libcosmic/"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/smithay-clipboard?tag=pop-dnd-5"]
git = "https://github.com/pop-os/smithay-clipboard"
tag = "pop-dnd-5"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/softbuffer?tag=cosmic-4.0"]
git = "https://github.com/pop-os/softbuffer"
tag = "cosmic-4.0"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/window_clipboard.git?tag=pop-0.13-2"]
git = "https://github.com/pop-os/window_clipboard.git"
tag = "pop-0.13-2"
replace-with = "vendored-sources"

[source."git+https://github.com/smithay/smithay//?rev=ce61c9b"]
git = "https://github.com/smithay/smithay//"
rev = "ce61c9b"
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "vendor"
' > ${SRC}/.cargo/config.toml
        "%,



        "cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/taffy",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/id-tree",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/smithay-egui",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/rust-atomicwrites",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/cosmic-protocols",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/cosmic-settings-daemon",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/cosmic-text",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/freedesktop-icons",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/glyphon",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/libcosmic",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/smithay-clipboard",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/softbuffer",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/window_clipboard",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/smithay",

"cp -r ${SRC}/vendor/cosmic-protocols/client-toolkit ${SRC}/vendor/cosmic-client-toolkit",
"cp ${SRC}/vendor/objc2-0.5.2/.cargo-checksum.json ${SRC}/vendor/cosmic-client-toolkit",

    ],

    release = false,

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBoth,
        drvs.pkgconf,
        llvmProvider,
        drvs.clangCc,
      ]
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.alsaLibs,
      drvs.atSpi2Core,
      drvs.bluez,
      drvs.cairo,
      drvs.cairoGobjectEmpty,
      drvs.dbus,
      drvs.eudev,
      drvs.expat,
      drvs.fdkAac,
      drvs.ffmpeg,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glib,
      drvs.gperf,
      drvs.gtk3,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.jansson,
      drvs.jsonC,
      drvs.kmod,
      drvs.ldacbt,
      drvs.libcamera,
      drvs.libdisplayinfo,
      drvs.libdlEgl,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      drvs.libfreeaptx,
      drvs.libinput,
      drvs.libjpegTurbo,
      drvs.libopus,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libsndfile,
      drvs.libusb,
      drvs.libxkbcommon,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.lua,
      drvs.m4,
      drvs.mesaExp,
      drvs.mtdev,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.sbc,
      drvs.seatd,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.utilLinux,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.pipewire,
      drvs.dinit,
      drvs.libstdcppCompat,
    ],
  },

  testFetcher | lib.DeterministicFetcher = {
    buildPhase = [
      "wget https://github.com/pop-os/cosmic-comp/archive/refs/tags/epoch-1.0.0-alpha.7.tar.gz",
      "cp epoch-1.0.0-alpha.7.tar.gz ${DEST}/out.tar.gz",
    ],
    outputFile = "out.tar.gz",
    outputSha256sum = "7bd9f19a69fb9708448d0a551d2c8bf5abf809457694f17aefd8d4d03b70d16d",
    biDrvs = [
      drvs.emptyResolvConf
    ]
  },
  emptyResolvConf | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/etc",
      "touch ${DEST}/etc/resolv.conf",
    ]
  }
}

&

{
  lib,
  drvs,
  cosmicCompSources | lib.DeterministicFetcher = {
      singleSource = {
      uri = "https://github.com/pop-os/cosmic-comp/archive/refs/tags/epoch-1.0.0-alpha.7.tar.gz",
      sha256sum = "7bd9f19a69fb9708448d0a551d2c8bf5abf809457694f17aefd8d4d03b70d16d"
    },
    extraEnv={
      HOME="/tmp/home"
  },
    separateBuildDir = false,
    buildPhase=[
      "mkdir -p $HOME",
      "mkdir -p .cargo",
      "cargo vendor --locked >> .cargo/config.toml",
      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically

      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "cp ../build/%{outputFile} ${DEST}",
    ],
    # outputSha256sum = "3ae4cb26d9fff4c7154b68bcbfedb84b9cc14cf5b85bfec71bd4239ef22bedcf",
    outputSha256sum = "163454290382acc2c491376355c67f93cdb72e1a2fe2056f21c0d4a41f8a1821",

    outputFile = "cosmic-comp-sources.tar",


    biDrvs = [
      drvs.emptyResolvConf,
      drvs.muslShared,
      drvs.rust,
      drvs.gitFull,
      drvs.caCertificates,
      # drsv.findutils & {priority = 1},
      # drsv.gnutar & {priority = 1},
    ]
  }
}