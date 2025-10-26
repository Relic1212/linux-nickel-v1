{
  drvs,
  lib = {
    CmakePackage,
    QtPackage =
      CmakePackage
      & {

        cmakeExtraArgsRecord = {

          "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\"",

          "-DQT_QPA_DEFAULT_PLATFORM" = "wayland",

          # https://github.com/gentoo/gentoo/blob/18dd27bd14c6b7856cdf271b53ca32526f05ce82/eclass/qt6-build.eclass#L290
          "-DQT_QPA_PLATFORMS" = "wayland",

          "-DINSTALL_MKSPECSDIR" = "/usr/lib/qt6/qml/mkspecs",
          "-DINSTALL_QMLDIR" = "/usr/lib/qt6/qml",
          "-DINSTALL_PLUGINSDIR" = "/usr/lib/qt6/plugins",
          "-DINSTALL_IMPORTDIR" = "/usr/lib/qt6/imports",
          "-DINSTALL_HEADERDIR" = "/usr/include/qt6",
          "-DINSTALL_BINDIR" = "/usr/lib/qt6/bin",
          "-DINSTALL_LIBEXECDIR" = "/usr/lib/qt6/libexec",

          "-DQT_USE_CCACHE" = true,
        },

        generator = "Ninja",

        buildEnv = {
          BASE_LDFLAGS = [
            # "-lc++",
            # "-lglapi",
            # "-ldrm",
            "$(pkg-config --libs --static gbm glesv2 dri egl)",
          ],
        }
      }
  }
}
