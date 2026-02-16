{
  lib,
  drvs,
  linuxWithBuild,
  ryzenSmu | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/amkillam/ryzen_smu/archive/d3bfbe97623a2a26c46c5b88b2053cfa2b08e91a.tar.gz",
      sha256sum = "8f17dd2f9d847268c5bda1a25792b1044c81f5a9a2a3cb17c4a6184e12a4c8bf",
    },
    options = { version = linuxWithBuild.options.version },

    extraMakeArgs = [
      "KERNELRELEASE=%{options.version}-standard",
      "KERNEL_DIR=/usr/lib/modules/%{options.version}-standard/build",
      "KERNEL_MODULES=/usr/lib/modules/%{options.version}-standard",
      "INSTALL_MOD_STRIP=1",
      "LLVM=1",
      "INSTALL_MOD_PATH=/tmp/workdir/out/destdir",
      # "DEPMOD=true",
      "MODLIB=${DEST}/usr/lib/modules/%{options.version}-standard",
      "TARGET=\"%{options.version}-standard\""
    ],
    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr"
      ],
    makeArgs,
    preInstallPhase = [
      "make %{std.string.join " " makeArgs} CC=clang LDFLAGS=\"${LDFLAGS}\" -C userspace",
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/modules/%{options.version}-standard/kernel/drivers/ryzen_smu/",
      "install -m0755 ryzen_smu.ko ${DEST}/usr/lib/modules/%{options.version}-standard/kernel/drivers/ryzen_smu",
      "install -dm0755 ${DEST}/usr/bin",
      "install -m0755 userspace/monitor_cpu ${DEST}/usr/bin",
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.linuxWithBuild,
      drvs.kmod & { priority = 1 },
      drvs.rsync,
      drvs.zstd,
    ],
  }
}
