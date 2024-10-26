{
  lib,
  xdgRuntimeRun | lib.Package
    = {
      name = "xdg-runtime-run",
      buildPhase = [
        m%"
echo '#!/bin/sh

mkdir -p "/tmp/run/$(id -u)"
chmod 0700 "/tmp/run/$(id -u)"
export XDG_RUNTIME_DIR="/tmp/run/$(id -u)"
exec $@' > xdg-runtime-run
"%,
        "chmod +x xdg-runtime-run",
      ],

      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 xdg-runtime-run ${DEST}/usr/bin",
      ]
    }
}
