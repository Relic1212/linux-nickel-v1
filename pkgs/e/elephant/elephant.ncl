{

  elephantSource | lib.DeterministicFetcher = {
    singleSource = {
      uri = "https://github.com/abenz1267/elephant/archive/refs/tags/v2.21.0.tar.gz",
      sha256sum = "7631900b656511ccd3e82e832c4feaab3796f4e074e7829d91dd1bd2402f5c16",
    },
    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      #   "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    buildPhase = [
      "go mod vendor -v",
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar --sort=name --mode=0755 -cf - . > ../build/%{outputFile}",
      # "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ../build/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",
    # outputSha256sum = "b187b5da68082a51e11a49bb902cd0b7732f9f45c872e3d26f798e52cca92cb6",
    outputSha256sum = "506d8870777e28ee437183de6706ac8788f332b345271b669568ecf636336b52",

    biDrvs = [
      drvs.go_1_26,
      drvs.emptyResolvConf,
      drvs.caCertificates,
      (drvs.gnutar & { priority = 1 }),
    ]
  },
  lib,
  drvs,
  elephant | lib.MakePackage =
    let cgo = true in
    {
      singleSource = {
        uri = "https://github.com/abenz1267/elephant/archive/refs/tags/v2.21.0.tar.gz",
        sha256sum = "7631900b656511ccd3e82e832c4feaab3796f4e074e7829d91dd1bd2402f5c16",
      },

      unpackPhase = [
        "(cd /tmp/workdir/src && tar xf /source.tar)",
      ],
      buildEnv.EXTRA_LDFLAGS = [
        "${SRC}/dlopen.o",
      ],

      extraMakeArgs = [
        m%"GO_BUILD_FLAGS="-buildvcs=false -trimpath -ldflags \"%{ if cgo then  "-linkmode 'external' " else "" }-extldflags '-static ${SRC}/dlopen.o'\"" "%,
      ],
      extraMakeInstallArgs =
        extraMakeArgs
        @ [
          "PREFIX=/usr"
        ],

      preConfigurePhase = [
        "export GOROOT=/usr/lib/go",
        "export GOMODCACHE=${SRC}/go-mod",
        "export CGO_ENABLED=1",
        "mkdir /tmp/home",
        "export HOME=/tmp/home",
        "echo '%{import "elephant_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
        "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      ],
      preBuildPhase = [
        "cd internal/providers/desktopapplications",
        # "sed -i 's@package main@package main_desktop@g' *.go",
        "go build -buildvcs=false -buildmode=plugin",
        m%"echo 'func main() {}' >> setup.go"%,

        # m%"go build -buildvcs=false -ldflags "-linkmode 'external' -extldflags '-static'" -buildmode=plugin -trimpath"%,
        # "go build -buildvcs=false -buildmode=archive -trimpath",
        # "go build -buildvcs=false -buildmode=archive *.go",
        "go build -buildvcs=false -buildmode=c-archive",
        "cp *.a ${DEST}",
        "cp *.so ${DEST}",
        "cd ${SRC}",
      ],

      muslProvider = drvs.muslBothRenamedDl,

      biDrvs = [
        drvs.elephantSource,
        drvs.go_1_26,
      ]
    }
}
