{
  lib,
  attr,
  acl,
  dbus,
  libcap,
  pcre2,
  libffi,
  zlibNg,
  glib,
  libxslt,
  gudev,
  eudev,
  linuxHeaders,
  gperf,
  pythonJinja2,
  muslGetent,
  utilLinux,
  bash,
  pythonMarkupsafe,
  pythonFlitCore,
  coreutils,

  elogind | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/elogind/elogind/archive/refs/tags/v255.17.tar.gz",
      sha256sum = "a9725ae3f73f8d910de84c108bc11bfd4c782bef6a4190b2ec70c5d2f22344db"
    },
    biDrvs =
      lib.biMap [
        attr,
        acl,
        dbus,
        libcap,
        pcre2,
        libffi,
        zlibNg,
        glib,
        libxslt,
        gudev,
        eudev,
        linuxHeaders,
        gperf,
        pythonJinja2,
        (coreutils & { priority = 1 }),
        muslGetent,
        utilLinux,
        bash,
        pythonMarkupsafe,
        pythonFlitCore,
      ],
    extraMesonArgs = [
      "-Dpolkit=false",
      "-Dutmp=false",
      "-Ddefault-user-shell=/bin/sh",
      "-Dpolkit=disabled",
      "-Dstatic-libelogind=true",
      "-Dtests=false",
    ],
    patches = [
      #   {
      #     sha256sum = "0eff09d96ee032493808317caca32414e60c8b7c54a32d4d9e9b1cfa7d92adc2",
      #     file = "0002-static.patch"
      #   },
      #   {
      #     sha256sum = "a53011aa0a761f951810062f14598e2a0528434aa93558bfdb5c6f11379dd075",
      #     file = "0003-static.patch"
      #   },
      #  { sha256sum = "38a5d100edbf7c42b93b1b8b6c360b68e7c917d036ec8ab5de6cfa0da7c48eae" , file =  "0008-syms.patch"},

      # {sha256sum="95bafc974cfb30011b785c6c43d5794abc047d8d32f9ff17ace95ecb62381666", file =  "0010-no-event.patch"}
    ],
    preConfigurePhase = [
      m%"    sed -i "s@ libpam_misc = cc.find_library('pam_misc', required : want_pam == 'true')@ libpam_misc = cc.find_library('pam_misc', required : false)@g" ${SRC}/meson.build"%
    ]
  }
}
