{
  lib,
  bash | lib.AutotoolsPackage
    = {
      configureFlags = lib.AutotoolsPackage.configureFlags @ ["--without-bash-malloc", "--disable-nls", "--with-curses=no", "--enable-readline=no"],
      sourceInputs = [
        {
          src = {
            uri = "https://ftp.gnu.org/gnu/bash/bash-5.2.32.tar.gz",
            sha256sum = "d3ef80d2b67d8cbbe4d3265c63a72c46f9b278ead6e0e06d61801b58f23f50b5"
          }
        }
      ]
    },
  bashSh | lib.Package
    = {
      postInstallPhase = [
        "install -d -m0755 ${DEST}/bin",
        "cd ${DEST}/bin",
        "ln -s /usr/bin/bash sh"
      ]
    },
  pkgs,
  bashAarch64 =
    bash
    & {
      buildEnv,
      configureFlags | priority 1
        =
          bash.configureFlags
          @ [
            "--host=aarch64-unknown-linux-musl"
          ],
      buildInputs = pkgs.busyboxAarch64.buildInputs,
      buildEnv.TARGET = "aarch64-unknown-linux-musl",
      buildEnv.CROSS_LDFLAGS = ["-nostdlib", "-lc"],
      buildEnv.CPP = ["clang-cpp", "-target aarch64-unknown-linux-musl"],

      extraEnv.CC_FOR_BUILD = ["clang"],
      extraEnv.LD_FOR_BUILD = ["ls.llld"],
      extraEnv.CPP_FOR_BUILD = ["clang-cpp"],
    }
}
