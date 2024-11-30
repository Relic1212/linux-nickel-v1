{
    lib,
    drvs,
    powertop | lib.AutomakePackage = {
        singleSource = {
            uri = "https://github.com/fenrus75/powertop/releases/download/v2.15/powertop.tar.gz",
            sha256sum = "e9590b82dee773b468b2eff4321a766c8bb04c45ccfa02b3127ee5af3359726b"
        },

        biDrvs = [
            drvs.ncurses,
            drvs.gettext,
        ],
        configureScript,
configureFlags,
    configurePhase =[
      
                "(cd ${SRC}; NOCONFIGURE=1 ./autogen.sh)",
                configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags),
              
    ],
    }
}