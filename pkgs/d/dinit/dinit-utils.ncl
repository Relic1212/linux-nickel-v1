{
  lib,
  drvs,
  distro,
  dinitUtils | lib.Package = {
    options = {
      selinux | default = distro.selinux,
    },

    buildEnv.EXTRA_CFLAGS =
      if options.selinux then
        [
          "-DSELINUX_ENABLED",
        ]
      else
        [],
    buildPhase = [
      lib.functions.writeFile "early-filesystems.c" (import "files-utils/early-filesystems.c" as 'Text),
      "${CC} ${CFLAGS} early-filesystems.c -o /tmp/workdir/build/mount-early",
      # "clang -static /tmp/workdir/files/early-filesystems.c -o /tmp/workdir/build/mount-early",
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/libexec",
      "install -m0755 /tmp/workdir/build/mount-early ${DEST}/usr/libexec",
    ],
    enableCcache = false,
    biDrvs = [
      drvs.llvm,
      drvs.musl,
    ]
  },
  dinitUtilsSh | lib.Package = {
    buildPhase = [
      lib.functions.writeFile
        "mount-early"
        (
          if distro.selinux then
            (import "files-utils/early-filesystems-selinux.sh" as 'Text)
          else
            (import "files-utils/early-filesystems.sh" as 'Text)
        ),
    ],
    installPhase = dinitUtils.installPhase,
  }
}
