{
  lib,
  pkgs,
  cryptsetup | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://www.kernel.org/pub/linux/utils/cryptsetup/v2.7/cryptsetup-2.7.5.tar.xz",
        sha256sum = "d2be4395b8f503b0ebf4b2d81db90c35a97050a358ee21fe62a0dfb66e5d5522",
      },
      biDrvs =
        lib.biMap [
          pkgs.utilLinux,
          pkgs.jsonC,
          pkgs.lvm2,
          pkgs.pkgconf,
          pkgs.openssl,
          pkgs.bash,
          pkgs.linuxHeaders,
          pkgs.popt,
        ],
      preConfigurePhase = [
        m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/tests/generate-symbols-list"%
      ],
      extraConfigureFlags = [
        "--disable-asciidoc",
        "--disable-nls",
        "--disable-ssh-token",
      ]
    }
}
