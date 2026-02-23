{
  lib,
  drvs,
  qtpluginConsumer | lib.LxqtPackage = {
    generator = "Ninja",
    singleSource = null,
    buildEnv = {
      EXTRA_LDFLAGS = [
        # "$(pkg-config --libs --static libinput gmodule-2.0 expat)",
        # "-Wl,--verbose",
      ],
    },
    preConfigurePhase = [
      "cat << 'EOF' > ${SRC}/qtbase.cpp\n%{import "qtbase.cpp" as 'Text}\nEOF",
      "cat << 'EOF' > ${SRC}/main.cpp\n%{import "main.cpp" as 'Text}\nEOF",
      "cat << 'EOF' > ${SRC}/CMakeLists.txt\n%{import "CMakeLists.txt" as 'Text}\nEOF",
    ],
    biDrvs = [
      # drvs.qtbase,
      # drvs.qtdeclarative,
      drvs.libevdev,
      drvs.mtdev,
    ]
  }
}
& (import "user/_qtplugin-consumer-user.ncl")