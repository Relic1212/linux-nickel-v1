{
  lib,
  drvs,
  keyd | lib.MakePackage = {
    singleSource = {

      uri = "https://github.com/rvaiya/keyd/archive/refs/tags/v2.5.0.tar.gz",
      sha256sum = "93ec6c153ef673a7a8b4d8b686494dee11d182513f4531c71dce15a8db7f6c1c",

      # uri = "https://github.com/rvaiya/keyd/archive/refs/tags/v2.6.0.tar.gz",
      # sha256sum = "697089681915b89d9e98caf93d870dbd4abce768af8a647d54650a6a90744e26",
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    biDrvs = [
      drvs.linuxHeaders
    ]
  },
  keydConfig | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}//etc/keyd",
      m%"printf "[ids]\n*\n" > ${DEST}/etc/keyd/default.conf"%,
    ]
  }
}
