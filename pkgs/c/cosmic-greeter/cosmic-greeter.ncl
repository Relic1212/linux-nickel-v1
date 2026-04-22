{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  _cosmicSrcs,

  cosmicGreeterSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-greeter",

      outputSha256sum = (import "src.sha256sum" as 'Text), # "696309af4c34285b91f19906360f40310ef0f2ceceefbb15d0847c1f79a5c1df"
    },
}
& {
  lib,
  drvs,
  cosmicGreeter | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      # m%"sed -i 's@"pulse",@@g' ${SRC}/vendor/cosmic-settings-subscriptions/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      # m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,

      # m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,

      # m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"clang-sys\/runtime"@"clang-sys\/static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      # m%"sed -i 's@default-features@#default-features@g' ${SRC}/vendor/pam-sys/Cargo.toml"%,
      m%"sed -i 's@default-features = false@default-features = false\nfeatures = \[ \"static\" \]@g' ${SRC}/vendor/pam-sys/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      "echo '%{import "../cosmic-osk/cosmic_osk_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",

      # m%"sed -i 's@\[\"libloading\"\]@false@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
    ],
    extraEnv = {
      # cosmic-epoch alpha
      VERGEN_GIT_COMMIT_DATE = "9e13a3e47a41296e815ecffef086746dd6bb44bc",
      VERGEN_GIT_SHA = "'Sat Apr 26 13:09:25 2025 +0530'",
      EXTRA_RUSTFLAGS = [
        "-C link-arg=-lcap",
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        m%"$(for l in $(pkg-config --libs --static xkbcommon);do printf " -C link-arg=$l ";done)"%,
      ],
    },
    patches = [
      # {
      #   sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
      #   file = "cosmic-osd-xkb.patch",
      # }
    ],
    release,

    target,
    cargoFlags,

    extraCargoFlags = [
      # "--verbose",
      "--no-default-features",
      "--features logind,upower"
    ],
    buildPhase = [
      # "just build-release %{std.string.join " " cargoFlags }",     
      "just build-release --offline --target x86_64-unknown-linux-musl --no-default-features --features logind,upower",
      "echo 'Done building'",
    ],

    installPhase =
      let d = if release then "release" else "debug" in
      [
        # "just --set bin-src \"target/%{target}/%{d}/cosmic-greeter\" rootdir=$DEST install",
        "CARGO_TARGET_DIR=\"target/%{target}/\" just rootdir=$DEST install",
      ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBothWeakDl,
        drvs.pkgconf,
        llvmProvider,
        drvs.clangCc,
      ]
      @ (if enableSccache then [drvs.sccache] else [])
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,
    enableSccache,
    enableSccache = false,
    biDrvs = [
      drvs.git,
      drvs.just,
      drvs.cosmicGreeterSources,
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
      drvs.libstdcppCompat,
      drvs.libpamFinal,
      drvs.libcap,
    ],
  },

  cosmicGreeterConfig | lib.Package = {

    installPhase = [
      "install -dm0755 ${DEST}/etc/greetd",

      # https://wiki.gentoo.org/wiki/COSMIC
      m%"
      echo '
      [terminal]
      vt = "3"

      [general]
      service = "cosmic-greeter"

      [default_session]
      command = "/usr/bin/dbus-run-session -- env lang=en_US.UTF8 /usr/bin/cosmic-comp /usr/bin/cosmic-greeter  2>&1 | /usr/bin/logger -t cosmic-greeter"
      user = "cosmic-greeter"
      ' > ${DEST}/etc/greetd/cosmic-greeter.toml
      "%,
      "install -dm0755 ${DEST}/etc/dinit.d",
      m%"
      echo '
      command = /usr/bin/greetd -c /etc/greetd/cosmic-greeter.toml
      depends-on = loginready
      waits-for = cosmic-greeter-daemon
      depends-on = cosmic-greeter-apply-perms
      logfile = /var/log/cosmic-greeter.log
      smooth-recovery = true
      type = process
      ' > ${DEST}/etc/dinit.d/cosmic-greeter
      "%,
      m%"
      echo '
      command = /usr/bin/chown -R cosmic-greeter:cosmic-greeter /var/lib/cosmic-greeter
      depends-on = varrw
      type = scripted
      ' > ${DEST}/etc/dinit.d/cosmic-greeter-apply-perms
      "%,
      m%"
      echo '
      command = /usr/bin/cosmic-greeter-daemon
      depends-on = loginready
      logfile = /var/log/cosmic-greeter-daemon.log
      smooth-recovery = true
      type = process
      ' > ${DEST}/etc/dinit.d/cosmic-greeter-daemon
      "%,
      "install -dm0755 ${DEST}/etc/pam.d",
      m%"
        echo "
        auth            optional pam_exec.so expose_authtok  debug  log=/var/log/unlock.log     /usr/libexec/crypto-pam
        auth            required        pam_securetty.so debug
        auth            include         system-auth
        account         required        pam_nologin.so
        account         include         system-auth
        password        include         system-auth
        session         include         system-auth
        session        required        pam_elogind.so debug
        " > ${DEST}/etc/pam.d/cosmic-greeter
        "%,
    ]
  }
}
