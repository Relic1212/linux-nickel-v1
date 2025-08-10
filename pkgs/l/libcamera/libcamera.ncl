{
    lib,
    drvs,
    libcamera | lib.MesonPackage = {
        singleSource = {
            uri = "https://gitlab.freedesktop.org/camera/libcamera/-/archive/v0.5.2/libcamera-v0.5.2.tar.gz",
            sha256sum = "51e6f95c791601b281b862fc88f5e95e977b50962ef2f5fef3af3083ac251442"
        },
        extraMesonArgs = [
            "-Dv4l2=enabled",
            "-Dudev=enabled",
            "-Dipas=''",
        ],
        preConfigurePhase = [
        m%"
      for f in $(find ${SRC} -name meson.build); do
        sed -i 's@shared_library@library@g' ${f}
      done
      "%,

      m%"
      for f in $(find ${SRC} -name meson.build); do
        sed -i 's@shared_module@library@g' ${f}
      done
      "%,
        ],
        patches = [
          # https://lists.libcamera.org/pipermail/libcamera-devel/2020-February/006780.html
          {
            file ="libcamera-no-dynamic.patch",
            sha256sum = "085bf4ffb743f6d19afbe8bef991a9bb66419cc993dd7bfca341a2c3a67c04f4"
          }
        ],
        pythonProvider = drvs.pythonDynamic,
        biDrvs = [
drvs.gperf,
      drvs.kmod,
      drvs.zlibNg,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.linuxHeaders,
      drvs.file,
                  drvs.eudev,

                  drvs.libyaml,
                  drvs.pyyaml,
                  drvs.pythonJinja2,

                  drvs.muslShared,
                  drvs.pybind11,

                       drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,

                  drvs.pythonPly,

                  (drvs.coreutils & { priority = 1})
        ]
    }
}