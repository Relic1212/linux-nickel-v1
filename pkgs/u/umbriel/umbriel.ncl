{
  lib,
  drvs,
  umbriel | lib.MesonPackage = {
    debug = true,
    singleSource = {
      uri = "https://github.com/noctalia-dev/umbriel/archive/d3bff0fb2458ede9726d0194554a159241cc856c.tar.gz",
      sha256sum = "f4af2a17d425b6e1ec8b80a6bcac363fac6ca794922b830da5670bf82d381384",
    },

    buildEnv = {
      EXTRA_CPPFLAGS =
        std.array.map
          (fun s => "-D%{s}=umbriel__%{s}")
          [
            "output_pending_resolution",
            "output_pending_image_description",
          ],
      EXTRA_LDFLAGS = [
        "-lGL",
      ],
    },

    extraMesonArgs = [
      "-Dtests=disabled",
    ],

    preConfigurePhase = [
      "dl-func > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "export LDFLAGS=\"${LDFLAGS} ${SRC}/dlopen.o\"",
      m%"sed -i 's@ throw std::runtime_error(std::string("umbrielfx scene helpers are not linked correctly: ") + mismatch);@//  throw std::runtime_error(std::string("umbrielfx scene helpers are not linked correctly: ") + mismatch);@g' ${SRC}/src/server/server.cpp"%,
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = if debug then drvs.muslBothRenamedDlDebug else drvs.muslBothRenamedDl,
    debug,
    biDrvs =
      (if debug then [drvs.bash] else [])
      @ [
        drvs.pythonDlFunc,
      ],
    pDrvs = [
      drvs.wlroots20xwayland,
      drvs.tomlplusplus,
      drvs.libei,
      drvs.nlohmannJsonCmake,
    ],
  }
}
