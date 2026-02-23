{
  lib,
  drvs,
  qtpluginConsumerUser | lib.LxqtPackage = {
    generator = "Ninja",
    singleSource = null,
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static libinput gmodule-2.0 expat)",
      ],
    },
    preConfigurePhase = [
      "cat << 'EOF' > ${SRC}/main.cpp\n%{import "../main.cpp" as 'Text}\nEOF",
      "cat << 'EOF' > ${SRC}/CMakeLists.txt\n%{import "CMakeLists.txt" as 'Text}\nEOF",
      # "mkdir ${SRC}/cmake",
      # "cat << 'EOF' > ${SRC}/cmake/AddStaticQtPlugins.cmake\n%{import "../AddStaticQtPlugins.cmake" as 'Text}\nEOF",

    ],
    biDrvs = [
      # drvs.qtbase,
      # drvs.qtdeclarative,
      drvs.libevdev,
      drvs.mtdev,
      drvs.qtpluginConsumer,
      drvs.qtpluginConsumerCmake,
    ]
  }
}
