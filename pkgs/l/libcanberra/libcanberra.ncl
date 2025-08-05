{
  lib,
  drvs,
  libcanberra | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz",
      sha256sum = "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"
    },
    extraConfigureFlags = [
      # https://github.com/stal-ix/ix/blob/58492794f6a75b60d06b4d61293f6a4654a8d102/pkgs/lib/canberra/ix.sh#L27
      "--with-builtin=alsa",
      "--enable-alsa",
    ],
    postInstallPhase = [
      m%"echo "
prefix=/usr
exec_prefix=\${prefix}
libdir=/usr/lib
includedir=/usr/include

Name: libcanberra
Description: Event Sound API
Version: 0.30
Libs: -L\${libdir} -lcanberra  -lltdl
Libs.private: -lltdl
Cflags: -D_REENTRANT -I\${includedir}
Requires: ogg vorbis alsa vorbisfile
Requires.private: ogg vorbis alsa vorbisfile
" >> ${DEST}/usr/lib/pkgconfig/libcanberra.pc
"%
    ],
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      #drvs.glib,
      #drvs.vala,
      drvs.libtool,
      drvs.gettext,
      drvs.pkgconf,
      drvs.libogg,
      drvs.libvorbis,
      drvs.linuxHeaders,
      drvs.alsaLibs,
      drvs.eudev,
      drvs.gperf,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
    ],
  }
}
