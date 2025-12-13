{
  lib,
  drvs,

  _muslBase | lib.AutotoolsPackage = {
    stage,
    isLlvm = (stage != 0),
    baseName = "musl",
    isStatic = false,
    muslProvider = drvs.musl,
    # buildEnv._isStatic |priority 1 = true,

    sourceInputs = [
      {
        src = { uri = "https://musl.libc.org/releases/musl-1.2.5.tar.gz", sha256sum = "a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4" }
      }
    ],
    patches = [
      {
        file = "CVE-2025-26519-1.patch",
        sha256sum = "0896fcdb5125d9d0723f4e165f13c209830e7045a75cba4e858060837cb7292e"
      },
      {
        file = "CVE-2025-26519-2.patch",
        sha256sum = "0620fcee4e8a4e52ebe1ea75e2b51d2197ebda242489c0586924eafa9e9606a1",
      },
    ],
    extraEnv | priority -10 = lib.AutotoolsPackage.extraEnv & (if isLlvm then { LIBCC_LDFLAGS = ["--rtlib=compiler-rt"] } else {}),
    #configureFlags | priority -10 = (lib.AutotoolsPackage.configureFlags @ ["--disable-shared"])
    debug,
    extraConfigureFlags = ["--enable-static", "--disable-shared"] @ (if debug then ["--enable-debug"] else []),
  },

  muslStage0 = _muslBase & { stage = 0 },

  muslStage1 | lib.AutotoolsPackage =
    _muslBase
    & {
      stage = 1,
      isLlvm | force = false,
      buildEnv = {
        _isLlvm | force = false,
        _isStatic = true,
      },

      buildInputs = [
        drvs.busyboxBootstrapStage0,
        drvs.bootstrapSymlinks,
        drvs.bootstrapStage0,
        drvs.gnumakeStage1,
        drvs.ccacheBin,
      ]
    },

  muslStage2 =
    _muslBase
    & {
      stage = 2,

      buildInputs = [
        drvs.busyboxStage1,
        drvs.llvmStage1,
        drvs.gnumakeStage2,
        drvs.ccacheBin,
        drvs.muslStage1
      ]
    },

  muslStage3 | lib.AutotoolsPackage =
    _muslBase
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs = [
        drvs.busyboxStage2,
        drvs.llvmStage2,
        drvs.gnumakeStage3,
        drvs.ccacheBin,
        drvs.muslStage2
      ]
    },
  musl | lib.AutotoolsPackage =
    _muslBase
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs = [
        drvs.busyboxStage3,
        drvs.llvmStage3,
        drvs.gnumakeStage4,
        drvs.ccacheBin,
        drvs.muslStage3,
      ]
    },
  muslShared =
    musl
    & {
      name = "musl-shared",
      extraConfigureFlags | priority 1 = ["--disable-static", "--enable-shared"],
    },
  muslBoth =
    musl
    & {
      extraConfigureFlags | priority 1 = ["--enable-static", "--enable-shared"],
    },
  muslBothRenamedDl =
    muslBoth
    & {
      debug = true,
      postInstallPhase = [
        "cd ${DEST}/usr/lib",
        # "objcopy -W dlopen libc.a",
        "objcopy --redefine-sym=dlopen=dlopen_libc libc.a",
        # "objcopy -W dlsym libc.a",
        "objcopy --redefine-sym=dlsym=dlsym_libc libc.a",
        "objcopy --redefine-sym=dladdr=dladdr_libc libc.a",
        "objcopy --globalize-symbol stub_dlopen libc.a",
        "objcopy --globalize-symbol stub_dlsym libc.a",
        "objcopy --globalize-symbol stub_dladdr libc.a",
      ]
    },
  muslBothWeakDl =
    muslBoth
    & {
      debug = true,
      postInstallPhase = [
        "cd ${DEST}/usr/lib",
        "objcopy -W dlopen libc.a",
        # "objcopy --redefine-sym=dlopen=dlopen_libc libc.a",
        "objcopy -W dlsym libc.a",
        # "objcopy --redefine-sym=dlsym=dlsym_libc libc.a",
        # "objcopy --redefine-sym=dladdr=dladdr_libc libc.a",
        "objcopy -W dladdr libc.a",
        "objcopy --globalize-symbol stub_dlopen libc.a",
        "objcopy --globalize-symbol stub_dlsym libc.a",
        "objcopy --globalize-symbol stub_dladdr libc.a",
      ]
    },
  muslDebug =
    _muslBase
    & {
      debug = true,
      extraConfigureFlags | priority 1 = ["--enable-static", "--enable-shared", "--enable-debug"],
    },
  muslAarch64 =
    musl
    & {
      extraConfigureFlags | priority 1 =
        musl.extraConfigureFlags
        @ [

          # "--target=aarch64-unknown-linux-musl",
          # "--build=x86_64-unknown-linux-gnu",
          "--host=aarch64-unknown-linux-musl"
        ],
      # buildEnv.CPP=["clang","--target=aarch64-unknown-linux-musl", "--sysroot=/aarch64-unknown-linux-musl","-E"],

      extraMakeArgs = [
        "TARGET=aarch64-linux-musl"
      ],
      # buildEnv.EXTRA_CFLAGS=["-target aarch64-unknown-linux-musl"],

      buildEnv.TARGET = "aarch64-unknown-linux-musl",

      biDrvs | priority 1 = [
        drvs.busybox,
        drvs.clangCross,
        drvs.gnumake,
        drvs.ccacheBin,
        # drvs.muslStage2
      ],
    }
}
