{
  lib,
  drvs,
  swig | lib.AutomakePackage = {
    singleSource = {
      # see https://github.com/SELinuxProject/selinux/commit/fb518ff492cd6a286f35b415cbd7fd0f6e3faedb
      #   uri = "https://github.com/swig/swig/archive/refs/tags/v4.5.0.tar.gz",
      #   sha256sum = "eb797b32194d5ed995f571f58839e2307a2e9b2d5cfa6ad1ec7b43f6663dc59a",

      uri = "https://github.com/swig/swig/archive/refs/tags/v4.4.1.tar.gz",
      sha256sum = "8bf32042beb7ee1eeb5c71aa15a62513d964893f84234f2cd77e4a8e2ed41e87",
    },
    configureScript,
    configureFlags,
    configurePhase = [
      "(cd ${SRC}; ./autogen.sh)",
      configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags),
    ],
    biDrvs = [
      drvs.gettext,
      drvs.autoconfArchive,
      drvs.bison,
    ],
    pDrvs = [
      drvs.pcre2,
    ]
  }
}
