{
  lib,
  ncurses,

  libedit | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.thrysoee.dk/editline/libedit-20240808-3.1.tar.gz",
      sha256sum = "5f0573349d77c4a48967191cdd6634dd7aa5f6398c6a57fe037cc02696d6099f",
    },
    biDrvs =
      lib.biMap [
        ncurses,
      ],
    # https://patchwork.ozlabs.org/project/buildroot/patch/1452127277-9538-1-git-send-email-sergio.prado@e-labworks.com/
    buildEnv.EXTRA_CFLAGS = [
      "-D__STDC_ISO_10646__=201103L"
    ]
  }
}
