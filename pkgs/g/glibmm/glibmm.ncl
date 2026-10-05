{
  lib,
  drvs,
  glibmm | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/glibmm/2.90/glibmm-2.90.0.tar.xz",
      sha256sum = "e2efa45643f16b9fea2d6299f2f403d672eaeacddf0ff7f8094e1af9b0f5980b"
    },
    pDrvs = [
      # drvs.pcre2,
      # drvs.libffi,
      # drvs.zlibNg,
      drvs.glib,
      # drvs.libsigcpp2,
      drvs.libsigcpp,
    ]
  }
}
& {
  lib,
  drvs,
  glibmm_2_4 | lib.MesonPackage = {
    enableParallel = false,
    singleSource = {
      # uri = "https://download.gnome.org/sources/glibmm/2.68/glibmm-2.68.2.tar.xz",
      # sha256sum = "91e0a8618f7b82db4aaf2648932ea2bcfe626ad030068c18fa2d106fd838d8ad"
      #uri = "https://download.gnome.org/sources/glibmm/2.83/glibmm-2.83.1.tar.xz",
      #sha256sum = "68350a823c33da8acfb1263715bb002a36c68346bd44c19ac4c3f0bd190fd2b1",
      # uri = "https://download.gnome.org/sources/glibmm/2.82/glibmm-2.82.0.tar.xz",
      # sha256sum = "38684cff317273615c67b8fa9806f16299d51e5506d9b909bae15b589fa99cb6",
      # uri ="https://download.gnome.org/sources/glibmm/2.49/glibmm-2.49.7.tar.xz",
      # sha256sum = "571d8ecd082a66fa7248f500063409c1f478edc36f553d0eb27cf6199dee0b25",
      # uri = "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.7.tar.xz",
      # sha256sum = "fe02c1e5f5825940d82b56b6ec31a12c06c05c1583cfe62f934d0763e1e542b3",
      # uri = "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.8.tar.xz",
      # sha256sum = "64f11d3b95a24e2a8d4166ecff518730f79ecc27222ef41faf7c7e0340fc9329",

      # uri = "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.9.tar.xz",
      # sha256sum = "5a026e5602085307c7dcb72b71b07261c40f80914277bef5f8d7f2ecab739bec",

      uri = "https://gitlab.gnome.org/GNOME/glibmm/-/archive/2.66.10/glibmm-2.66.10.tar.bz2",
      sha256sum = "6701e77f3241b2a712be0388fd2d6df2a0b75af671d2ff613b4808a9ade6e06d",
    },

    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-Iglib",
      ],
    },

    extraMesonArgs = [
      "-Dbuild-examples=false",
      "-Dmaintainer-mode=true",
      "-Dbuild-documentation=false",
    ],

    preConfigurePhase =
      let
        dbus_f = [
          "${SRC}/untracked/gio/giomm/dbusactiongroup.h",
        ],
        emblem_f = [
          "${SRC}/untracked/gio/giomm/emblem.h",
          "${SRC}/untracked/gio/giomm/dbusactiongroup.h",
        ]
      in
      [
        m%"sed -i "s@subdir('tests')@# subdir('tests')@g" ${SRC}/meson.build"%,
        # m%"sed -i 's@using GDBusActionGroupClass = struct _GDBusActionGroupClass;@@g' %{std.string.join " " emblem_f}"%,
        # m%"sed -i 's@using GEmblemClass = struct _GEmblemClass;@@g'  %{std.string.join " " dbus_f}"%,
      ],
    preBuildPhase =
      let headers = [
        "glib/glibmm/balancedtree.h",
        "glib/glibmm/binding.h",
        "glib/glibmm/bytes.h",
        "glib/glibmm/bytearray.h",
        "glib/glibmm/checksum.h",
        "glib/glibmm/convert.h",
        "glib/glibmm/date.h",
        "glib/glibmm/datetime.h",
        "glib/glibmm/enums.h",
        "glib/glibmm/fileutils.h",
        "glib/glibmm/iochannel.h",
        "glib/glibmm/keyfile.h",
        "glib/glibmm/markup.h",
        "glib/glibmm/miscutils.h",
        "glib/glibmm/module.h",
        "glib/glibmm/nodetree.h",
        "glib/glibmm/optioncontext.h",
        "glib/glibmm/optionentry.h",
        "glib/glibmm/optiongroup.h",
        "glib/glibmm/regex.h",
        "glib/glibmm/shell.h",
        "glib/glibmm/spawn.h",
        "glib/glibmm/thread.h",
        "glib/glibmm/threads.h",
        "glib/glibmm/timezone.h",
        "glib/glibmm/unicode.h",
        "glib/glibmm/uriutils.h",
        "glib/glibmm/valuearray.h",
        "glib/glibmm/variant.h",
        "glib/glibmm/variantdict.h",
        "glib/glibmm/variantiter.h",
        "glib/glibmm/varianttype.h",
        "glib/glibmm/value_basictypes.h",
        "glib/glibmm/variant_basictypes.h",
        "glib/glibmm/dummy_header.h",
      ]
      in
      [
        #"ninja glib/glibmm/enums.h glib/glibmm/iochannel.h glib/glibmm/balancedtree.h glib/glibmm/datetime.h glib/glibmm/binding.h",
      ]
      @ (std.array.map (fun s => "ninja %{s}") headers),

    biDrvs = [
      drvs.mmCommon,
      drvs.doxygen,
      drvs.libxslt,
      # drvs.perl,
      drvs.perlDynamic,
      drvs.perlXmlParserDynamic,
      drvs.muslShared,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libsigcpp2,
      drvs.m4,
    ],
  }
}
