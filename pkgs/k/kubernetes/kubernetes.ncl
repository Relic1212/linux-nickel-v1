{
  lib,
  drvs,

  kubernetesSource | lib.DeterministicFetcher = {
    singleSource = {
      uri = "https://github.com/kubernetes/kubernetes/archive/refs/tags/v1.36.3.tar.gz",
      sha256sum = "950f7dd65b64b18ca065a08ae73dd5f61ff72b48c8778c5bfceacc84eaaf10ed",
    },
    separateBuildDir = false,
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    buildPhase = [
      "go work vendor -v",
      "chown -R root:root .",
      "chmod -R 755 .",
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar --sort=name -cf - . > ${BUILDDIR}/%{outputFile}",
    ],
    installPhase = [
      "install -m0755 ${BUILDDIR}/%{outputFile} ${DEST}/%{outputFile}"
    ],
    outputFile = "source.tar",

    outputSha256sum = "22abaff1cc3ff5a1d5cbb66403ca589a975b5fd88c8b8c1da8f0eba6a096be7d",

    biDrvs = [
      drvs.go_1_26,
      drvs.emptyResolvConf,
      drvs.caCertificates,
      (drvs.gnutar & { priority = 1 }),
      drvs.basefiles,
    ]
  },

  kubernetes | lib.MakePackage = {
    unpackPhase = [
      "tar xf /source.tar -C /tmp/workdir/src",
    ],

    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export GOTOOLCHAIN=local",
      "export CGO_ENABLED=0",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    preInstallPhase = [
      "hack/update-generated-docs.sh",
    ],

    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "install -m0755 _output/bin/* ${DEST}/usr/bin",
      "install -dm0755 ${DEST}/usr/share/man",
      "cp -r docs/man/* ${DEST}/usr/share/man",
    ],

    biDrvs = [
      drvs.bash,
      drvs.go_1_26,
      drvs.kubernetesSource,
    ],
  }
}
