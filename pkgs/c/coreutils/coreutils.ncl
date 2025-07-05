{
  lib,
  coreutils | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://mirrors.ibiblio.org/gnu/coreutils/coreutils-9.5.tar.xz",
      sha256sum = "cd328edeac92f6a665de9f323c93b712af1858bc2e0d88f3f7100469470a1b8a",
    },
    extraEnv = {
      FORCE_UNSAFE_CONFIGURE = "1"
    },

    extraConfigureFlags = [

      # https://coreutils.gnu.narkive.com/FUwMO7lI/stdbuf-util-prevents-easy-static-building-of
      "-enable-no-install-program=stdbu"
    ]
  }
}
