{
  lib,
  drvs,
  git | lib.AutotoolsPackage = {
    name = "git",
    singleSource = {
      uri = "https://www.kernel.org/pub/software/scm/git/git-2.39.0.tar.xz",
      sha256sum = "ba199b13fb5a99ca3dec917b0bd736bc0eb5a9df87737d435eddfdf10d69265b",
    },
    buildDir = "${SRC}",
    # extraConfigureFlags=[
    #     "--without-iconv",
    #     "--without-tcltk",
    #     "--disable-nls",
    #   "NO_TCLTK=YesPlease" ,"NO_GETTEXT=YesPlease", "MSGFMT=/usr/bin/true",

    # ],
    extraMakeArgs = [
      "NO_TCLTK=YesPlease",
      "NO_GETTEXT=YesPlease" #, "MSGFMT=/usr/bin/true",
    ],
    extraMakeInstallArgs = extraMakeArgs,
    biDrvs = [
      drvs.zlibNg,
    ]
  }
}
& {
  lib,
  drvs,
  git,
  gitFull | lib.AutotoolsPackage = {
    singleSource = git.singleSource,

    extraMakeArgs = [
      "CURL_LDFLAGS='-lcurl -lpsl -lssl -lcrypto -lz'",
      "NO_TCLTK=YesPlease",
      "NO_GETTEXT=YesPlease" #, "MSGFMT=/usr/bin/true",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lcurl",
        "-lpsl",
        "-lssl",
        "-lcrypto",
        "-lz"
      ]
    },
    extraMakeInstallArgs = extraMakeArgs,
    separateBuildDir = false,
    biDrvs = [
      drvs.zlibNg,
      drvs.curl,
      drvs.openssl,
      drvs.pkgconf,
      drvs.libpsl,
      drvs.openssh,
      drvs.linuxHeaders,
      drvs.expat,
      drvs.perl,
    ],
  }
}
