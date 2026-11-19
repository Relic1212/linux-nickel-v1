{
  lib,
  drvs,
  python,
  pythonFirefox | lib.AutotoolsPackage = {
    singleSource = python.singleSource,
    isStatic = false,
    extraConfigureFlags = [
      "--disable-profiling",
      "--disable-pystats",
      "--without-ensurepip",
      "--build=x86_64-unknown-linux-gnu",
      "--host=x86_64-unknown-linux-gnu",
      "--target=x86_64-unknown-linux-gnu",
    ],
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.opensslPic,
      drvs.zlibNgPic,
      drvs.ncursesPic,
      drvs.zstd,
      drvs.bzip2,
      drvs.readlinePic,
      drvs.muslShared,
      drvs.linuxHeaders,
      drvs.libffi,
      drvs.sqlitePic,
    ],
    postInstallPhase = [
      "cd $DEST/usr/bin",
      "ln -s python3 python",
    ]
  }
}
#
&
#
{
  lib,
  drvs,
  sqlite,
  sqlitePic | lib.AutotoolsPackage =
    sqlite
    & {
      buildEnv._isPic = true,
    },
}
#
&
#
{
  lib,
  drvs,
  nss,
  nssFirefox | lib.MakePackage =
    nss
    & {

      singleSource | priority 1 = {
        # uri = "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_126_RTM/src/nss-3.126.tar.gz",
        # sha256sum = "7aa07c758be1453d82d739240b249ffb7aef0041be488067e1c0f348e1f9e337",
        uri = "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_129_RTM/src/nss-3.129.tar.gz",
        sha256sum = "38baa3b0a18a3f674843473b549753c96419a0151abd1e7a9b214ce0493d0785",
      },
      enableParallel = false,
      options.args | priority 1 =
        nss.options.args
        @ [
          "-j 1",
          "--system-sqlite",
          "-t x64",
        ],
      pDrvs | priority 1 =
        nss.pDrvs
        @ [
          drvs.sqlite,
        ],
      preBuildPhase = [
        "set +e",
      ],
      installPhase | priority 1 = [
        "set -e",
        # "bas_e",
        # "ninja "
        "echo 'installPhase starting'",
        "install -dm0755 ${DEST}/usr/lib/pkgconfig",
        "install -dm0755 ${DEST}/usr/include/nss",
        "cp -rv ../dist/public/nss/* ${DEST}/usr/include/nss/",
        "cp -v ../dist/Release/lib/*.a ${DEST}/usr/lib/",
        # "cp ../dist/Release/lib/*.a ${DEST}/usr/lib/pkgconfig/",
        "echo 'sedding'",
        "sed -e 's@%prefix%@/usr@g' -e 's@%exec_prefix%@/usr/bin@g' -e 's@%libdir%@/lib@g' -e 's@%includedir%@/usr/include/nss@g' -e 's@%NSS_VERSION%@3.129@g' -e 's@%NSPR_VERSION%@1@g' $SRC/nss/pkg/pkg-config/nss.pc.in > ${DEST}/usr/lib/pkgconfig/nss.pc",
        "echo 'sedding done'",
        "cd ${DEST}/usr/lib/",
        # "mv libnssutil.a libnssutil3.a",
        # "mv libnss_static.a libnss3.a",
        # "mv libsmime.a libsmime3.a",
        # "mv libssl.a libssl3.a",
        # "llvm-objcopy --redefine-sym=C_GetInterface=nssckbi__C_GetInterface libnssckbi.a",
        "llvm-objcopy --redefine-sym=C_GetFunctionList=nssckbi__C_GetFunctionList libnssckbi.a",
      ],
      postInstallPhase = [
        "echo 'postInstallPhase starting'",
        "mv ${DEST}/usr/lib/libssl.a ${DEST}/usr/lib/libssl_nss.a"
      ]
    },
}
& {
  lib,
  drvs,
  firefoxGlxtestDl | lib.DlPackage = {
    libName = "firefox-glxtest-dlopen",
    libs =
      let r = import "_dl.ncl" in
      [
        r.pci,
        r.egl,
        r.gles,
        r.zzz_main,
      ]
  },
}
& {
  lib,
  drvs,
  openssl,
  opensslFirefox =
    openssl
    & {
      postInstallPhase =
        std.array.map
          (fun s => "llvm-objcopy --redefine-sym=%{s}=openssl__%{s} ${DEST}/usr/lib/libcrypto.a"
          )
          [
            "SEED_set_key",
            "SEED_encrypt",
            "SEED_decrypt",
            "SEED_ecb_encrypt",
            "SEED_cbc_encrypt",
          ]
    }
}

#
# &
# #
# {
#   lib,
#   drvs,
#   nssUnified | lib.Package =
#     let libs = [
#       "libcertdb.a",
#       "libcerthi.a",
#       "libcpputil.a",
#       "libcryptohi.a",
#       "libfreebl.a",
#       "libfreebl3.a",
#       "libfreebl_static.a",
#       "libfreeblpriv3.a",
#       # "libgcm-nodepend.a",
#       "libgcm.a",
#       "libghash-aes-x86_c_lib.a",
#       "libhw-acc-crypto-avx.a",
#       "libhw-acc-crypto-avx2.a",
#       # "libintel-gcm-wrap-nodepend_c_lib.a",
#       "libintel-gcm-wrap_c_lib.a",
#       "libjar.a",
#       "libmozpkix-testlib.a",
#       "libmozpkix.a",
#       "libnss3.a",
#       "libnss_static.a",
#       "libnssb.a",
#       "libnssckbi.a",
#       "libnssckfw.a",
#       "libnssdev.a",
#       "libnsspki.a",
#       "libnsssysinit.a",
#       "libnsssysinit_static.a",
#       "libnssutil.a",
#       "libnssutil3.a",
#       "libpk11wrap.a",
#       "libpk11wrap_static.a",
#       "libpkcs12.a",
#       "libpkcs7.a",
#       "libsectool.a",
#       "libsha-x86_c_lib.a",
#       "libsmime.a",
#       "libsmime3.a",
#       "libsoftokn.a",
#       "libsoftokn3.a",
#       "libsoftokn_static.a",
#       "libssl3.a",
#       "libssl_nss.a",
#     ]
#     in
#     {
#       buildPhase =
#         (std.array.map_with_index (fun index s => "mkdir %{index}\n(cd %{index} && ${AR} x /usr/lib/%{s}) ") libs)
#         @ [
#           "${AR} rcs libnss.a */*",
#         ],
#       installPhase = [
#         "install -dm0755 ${DEST}/usr/lib",
#         "install -m0755 libnss.a ${DEST}/usr/lib",
#       ],
#       biDrvs = [
#         drvs.nssFirefox,
#         drvs.llvm,
#       ]
#     }
# }
