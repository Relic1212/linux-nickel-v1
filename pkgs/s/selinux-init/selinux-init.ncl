{
  lib,
  drvs,
  selinuxInit | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      lib.functions.writeFile "${DEST}/usr/bin/initse" (import "initse.sh" as 'Text),
      "chmod +x ${DEST}/usr/bin/initse",
      lib.functions.writeFile "${DEST}/usr/bin/initwrap" (import "initwrap.sh" as 'Text),
      "chmod +x ${DEST}/usr/bin/initwrap",
    ]
  }
}
