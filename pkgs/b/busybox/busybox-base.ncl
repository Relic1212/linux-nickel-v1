let cmpFun = (fun x => (if x == null then [] else x))
in

{
  lib,
  _busyboxBase | lib.MakePackage
    = {
      # buildEnv =
      #   (lib.MakePackage.buildEnv)
      #   & {
      #     CPPFLAGS | priority -1000 = []
      #   },
      buildEnv.CPPFLAGS | priority -1000 = [],
      buildEnv,
      baseName = "busybox",
      sourceInputs = [
        {
          src = {
            uri = "https://busybox.net/downloads/busybox-1.37.0.tar.bz2",
            sha256sum = "3311dff32e746499f4df0d5df04d7eb396382d7e108bb9250e7b519b837043a4",
          }
        },
      ],
      buildDir = "/tmp/workdir/src",
      # extraEnv={
      #   EXTRA_CFLAGS=buildEnv.CFLAGS,
      #   EXTRA_LDFLAGS=buildEnv.LDFLAGS,
      #   EXTRA_CXXFLAGS=buildEnv.CXXFLAGS,

      # },
      makeArgs | priority 1
        =
          (lib.MakePackage.makeArgs)
          @ [
            "CC=%{lib.functions.varToExportvar buildEnv.CC} \\\n",
            "LD=%{lib.functions.varToExportvar buildEnv.CC} \\\n",
            "HOSTLD=%{lib.functions.varToExportvar buildEnv.CC} \\\n",
            "CXX=%{lib.functions.varToExportvar buildEnv.CXX} \\\n",
            "CPP=%{lib.functions.varToExportvar buildEnv.CXX} \\\n",
            "HOSTCC=%{lib.functions.varToExportvar buildEnv.CC} \\\n",
            "HOSTCXX=%{lib.functions.varToExportvar buildEnv.CXX} \\\n",
            "LDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
            "EXTRA_CPPFLAGS=%{ lib.functions.varToExportvar (cmpFun buildEnv.CPPFLAGS)} \\\n",
            "CXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
            "CFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
            "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
            "HOSTCPPFLAGS=%{ lib.functions.varToExportvar (cmpFun buildEnv.CPPFLAGS)} \\\n",
            "HOSTCXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
            "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
            "EXTRA_LDFLAGS=%{ lib.functions.varToExportvar  buildEnv.LDFLAGS} \\\n",
            "EXTRA_CXXFLAGS=%{ lib.functions.varToExportvar buildEnv.CXXFLAGS} \\\n",
            "EXTRA_CFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
            "SYSROOT=\"/tmp/workdir/sysroot\"",

            # "CPPFLAGS=\"${CPPFLAGS}\"",
            # "CFLAGS=\"${CFLAGS}\"",
            # "CXXFLAGS=\"${CFLAGS}\"",
            # "EXTRA_LDFLAGS=\"${LDFLAGS}\"",
            # "EXTRA_CPPFLAGS=\"${CPPFLAGS}\"",
            # "EXTRA_CFLAGS=\"${CFLAGS}\"",
            # "EXTRA_CXXFLAGS=\"${CFLAGS}\"",
          ]
      # @(if std.record.has_field "LD" buildEnv then         ["LD=%{buildEnv.LD}"] else [])
      ,
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 ${SRC}/busybox ${DEST}/usr/bin",
        "cd ${DEST}/usr/bin",
        m%"for link in $(./busybox --list); do
              ln -s /usr/bin/busybox ${link}
           done"%,
        "install -d -m0755 ${DEST}/bin",
        "cd  ${DEST}/bin",
        "ln -s /usr/bin/busybox sh",
      ],

      patches = [
        {
          file = "0001-mergedusr.patch",
          sha256sum = "285e29f7248943689f4de3c092ef344d1ac8ace24f0cd0d3ab813a6959757a20" # let s=import 'Raw "./patches/0001-mergedusr.patch" in lib.functions.computeSha256 s
        }
      ],
    },

  _busyboxBaseTarget | lib.MakePackage
    =
      _busyboxBase
      & {

        makeArgs,
        extraFiles = [
          {
            file = "busybox.config",
            sha256sum = "f457f5f43dabb9bbda657e542c76553ced78ecfbd739ca216ac594a622779e96" #let s=import 'Raw "./files_minimal/busybox.config" in lib.functions.computeSha256 s
          }
        ],
        buildDir,

        configurePhase = [
          "cd %{buildDir}",
          "unset CPPFLAGS",
          "cp /tmp/workdir/files/busybox.config .config",
          "sed -i 's@-falign-jumps=1@@g' Makefile.flags",
          "sed -i 's@-falign-labels=1@@g' Makefile.flags",
          "sed -i 's@-finline-limit=0@@g' Makefile.flags",
          "make " ++ (std.string.join " " makeArgs) ++ " oldconfig"
        ],
      }
}
