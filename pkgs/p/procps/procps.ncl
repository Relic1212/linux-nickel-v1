{
  lib,
  drvs,
  procps | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://sourceforge.net/projects/procps-ng/files/Production/procps-ng-4.0.4.tar.xz",
        sha256sum = "22870d6feb2478adb617ce4f09a787addaf2d260c5a8aa7b17d889a962c5e42e"
      },
      biDrvs = [
        drvs.pkgconf,
        drvs.ncurses,
      ],
      
    }
}
