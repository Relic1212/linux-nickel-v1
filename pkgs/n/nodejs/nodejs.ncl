{
  lib,
  drvs,
  nodejs | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://github.com/nodejs/node/archive/refs/tags/v25.9.0.tar.gz",
      # sha256sum = "4c64065e0cc91802fb052835d93ce56134dbce483717cb8ce6c48dd1f67657c6",
      # uri = "https://github.com/nodejs/node/archive/refs/tags/v22.23.3.tar.gz",
      # sha256sum = "8713facfc8b21c631c42f8ee5264023a78876a99e06e1ea8659649b5b4a690bc",

      uri = "https://github.com/nodejs/node/archive/refs/tags/v26.10.0.tar.gz",
      sha256sum = "dadc307a5353706728704a90316800df6834cb4928d0a227451295166a3b3d27",
    },
    separateBuildDir = false,
    configureFlags = [
      "--prefix=/usr",
      "--fully-static",
      # "--without-lief",
      "--with-intl=small-icu",
      "--without-sqlite",
      "--use_clang",
      "--without-inspector", # sqlit3.h
    ],

    preConfigurePhase = [
      m%"sed -i "s@#include <algorithm>@#include <algorithm>\n#include <iterator>@g" ${SRC}/deps/ada/ada.cpp"%,
      m%"sed -i "s@#include <iosfwd>@#include <iosfwd>\n#include <vector>@g" ${SRC}/deps/v8/src/codegen/source-position.h"%,
      m%"sed -i "s@#include <sys/types.h>@#include <sys/types.h>\n#include <vector>@g" ${SRC}/deps/v8/src/strings/unicode.h"%,
      m%"sed -i "s@#include <memory>@#include <memory>\n#include <vector>@g" ${SRC}/deps/v8/src/interpreter/interpreter.h"%,
      m%"sed -i "s@#include \"base.h\"@#include \"base.h\"\n#include <cstdlib>@g" ${SRC}/deps/LIEF/third-party/spdlog/include/spdlog/fmt/bundled/format.h"%,
      m%"sed -i "s@#include <utility>@#include <utility>\n#include <functional>@g" ${SRC}/deps/LIEF/third-party/frozen/include/frozen/map.h"%,
    ],
    biDrvs = [
      drvs.pythonInteractive,
      drvs.linuxHeaders,
      drvs.libemptyAtomic,
      drvs.libempty,
    ]
  },
  nodejsDynamic | lib.AutotoolsPackage = {
    singleSource = nodejs.singleSource,
    buildEnv._isStatic = false,
    isStatic = false,
    separateBuildDir = false,

    configureFlags = [
      "--prefix=/usr",
      "--without-lief",
      "--with-intl=small-icu",
      "--without-sqlite",
      "--use_clang",
    ],

    biDrvs = [
      drvs.pythonInteractive,
      drvs.linuxHeaders,
      drvs.libemptyAtomic,
      drvs.libempty,
      drvs.muslShared,
    ],
  }
}
