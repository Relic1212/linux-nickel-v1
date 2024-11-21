{
  lib,
  drvs,
  podman | lib.MakePackage
    = {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/containers/podman/archive/refs/tags/v5.3.0.tar.gz",
            sha256sum = "e160ecb00f87d78d611f3b3d54c5ab833657f365442dce2631c92b435b2d3bfb"
          }
        },
        # {
        #   src = {
        #         },
        #   dest = "go-mod",
        # }
      ],
      biDrvs = [
        drvs."go-1.23",
        drvs.bash,
        drvs.linuxHeaders,
        drvs.pkgconf,
        drvs.pcre2,
        drvs.pythonFull,
        (drvs.gnugrep & { priority = 1 }),
        (drvs.mandoc & { priority = 1 }),

        drvs.gpgme,
        drvs.libgpgError,
        drvs.libassuan,
        drvs.libseccomp,
      ],
      buildEnv ={
        EXTRA_LDFLAGS=["-lassuan","-lgpg-error","-lgpgme","-Wl,--no-gc-sections","--verbose"],
        EXTRA_CFLAGS=["--verbose"],

      },
      extraEnv = {
        CGO_LDFLAGS = buildEnv.EXTRA_LDFLAGS @ [ "-static","--static" ],
        GOGCCFLAGS =   ["-static","--static","-Wl,--no-gc-sections","--verbose"],

      },
      configurePhase = [
        "export GOROOT=/usr/lib/go",
        "export GOMODCACHE=${SRC}/go-mod",
        #"export CGO_ENABLED=0",
        "mkdir /tmp/home",
        "export HOME=/tmp/home",
      ],
      buildPhase =[
        m%"make \
            -j$(nproc) \
            PREFIX=/usr \
            EXTRA_LDFLAGS="-linkmode external -extldflags=-static " \
            EXTRA_BUILDTAGS="osusergo netgo" \
            podman
        "%,
        m%"CGO_ENABLED=0 make \
            -j$(nproc) \
            PREFIX=/usr \
            EXTRA_LDFLAGS="-linkmode external -extldflags=-static " \
            EXTRA_BUILDTAGS="osusergo netgo" \
            rootlessport
        "%,
         
         m%"CGO_ENABLED=1 make \
            -j$(nproc) \
            PREFIX=/usr \
            EXTRA_LDFLAGS="-linkmode external -extldflags=-static " \
            EXTRA_BUILDTAGS="osusergo netgo" \
            podman-remote podmansh podman-testing 
        "%,
        m%"CGO_ENABLED=1 make \
            -j$(nproc) \
            PREFIX=/usr \
            EXTRA_LDFLAGS="-linkmode external -extldflags=-static " \
            EXTRA_BUILDTAGS="osusergo netgo" \
            docs
        "%

      ],

      installPhase = [
        "export DESTDIR=${DEST}",
        "install -d -m 755 ${DESTDIR}/usr/bin",
        "install -m 755 bin/podman ${DESTDIR}/usr/bin/podman",
        "ln -sf podman ${DESTDIR}/usr/bin/podmansh",
        "install -d -m 755 ${DESTDIR}/usr/libexec",
        "install -m 755 bin/rootlessport ${DESTDIR}/usr/libexec/rootlessport",
        "make DESTDIR=${DEST} PREFIX=/usr install.man"
      ]
    }
}
& {
  lib,
  drvs,
  gpgme | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://gnupg.org/ftp/gcrypt/gpgme/gpgme-1.24.0.tar.bz2",
        sha256sum = "61e3a6ad89323fecfaff176bc1728fb8c3312f2faa83424d9d5077ba20f5f7da"
      },
      biDrvs = [
        drvs.libassuan,
        drvs.libgpgError,
      ],
      preConfigurePhase = [
        "sed -i 's@off64_t@off_t@g' ${SRC}/src/posix-io.c",
        "sed -i 's@ino64_t@ino_t@g' ${SRC}/src/posix-io.c",
      ],
      extraEnv = {
        LDFLAGS_FOR_BUILD = [
          "-static",
          "--static"
        ],
        CC_FOR_BUILD = ["clang", "-static", "--static"]
      },
      extraConfigureFlags = [
        "--disable-glibtest",
        "--disable-gpgconf-test",
        "--disable-gpg-test",
        "--disable-gpgsm-test",
        "--disable-g13-test",
      ]
    }
}
& {
  lib,
  drvs,
  gnupg | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.6.tar.bz2",
        sha256sum = "95acfafda7004924a6f5c901677f15ac1bda2754511d973bb4523e8dd840e17a"
      },
      biDrvs = [
        drvs.libgpgError,
        drvs.libassuan,
        drvs.libgcrypt,
        drvs.npth,
        drvs.libksba,
      ]
    }
}
& {
  lib,
  drvs,
  libgpgError | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.51.tar.bz2",
        sha256sum = "be0f1b2db6b93eed55369cdf79f19f72750c8c7c39fc20b577e724545427e6b2"
      },
      extraEnv = {
        LDFLAGS_FOR_BUILD = ["-static", "--static"]
      }
    }
}
& {
  lib,
  drvs,
  libassuan | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.1.tar.bz2",
        sha256sum = "c8f0f42e6103dea4b1a6a483cb556654e97302c7465308f58363778f95f194b1"
      },
      biDrvs = [
        drvs.libgpgError,
      ],
      extraEnv = {
        LDFLAGS_FOR_BUILD = ["-static", "--static"]
      }
    }
}
& {
  lib,
  drvs,
  libgcrypt | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.0.tar.bz2",
        sha256sum = "09120c9867ce7f2081d6aaa1775386b98c2f2f246135761aae47d81f58685b9c"
      },
      biDrvs = [
        drvs.libgpgError,
      ],
      extraEnv = {
        LDFLAGS_FOR_BUILD = ["-static", "--static"]
      }
    }
}
& {
  lib,
  drvs,
  libksba | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.7.tar.bz2",
        sha256sum = "cf72510b8ebb4eb6693eef765749d83677a03c79291a311040a5bfd79baab763"
      },
      biDrvs = [
        drvs.libgpgError,
      ],
      extraEnv = {
        LDFLAGS_FOR_BUILD = ["-static", "--static"],
      }
    }
}
& {
  lib,
  drvs,
  npth | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://gnupg.org/ftp/gcrypt/npth/npth-1.8.tar.bz2",
        sha256sum = "8bd24b4f23a3065d6e5b26e98aba9ce783ea4fd781069c1b35d149694e90ca3e"
      }
    }
}
& {
  lib,
  drvs,
  gnugrep | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://mirrors.kernel.org/gnu/grep/grep-3.11.tar.xz",
        sha256sum = "1db2aedde89d0dea42b16d9528f894c8d15dae4e190b59aecc78f5a951276eab"
      },
      extraConfigureFlags = [
        "--enable-perl-regexp"
      ],
      biDrvs = [
        drvs.pcre2,
      ]
    }
}
& {
  lib,
  drvs,
  libseccomp | lib.AutomakePackage
    = {
      singleSource = {
        uri = "https://github.com/seccomp/libseccomp/archive/refs/tags/v2.5.5.tar.gz",
        sha256sum = "7082b016d3cbda3e15c0e71ebd018023d693bb7507389b32f943db13f935e01d"
      },
      biDrvs = [
        drvs.pythonFull,
        drvs.gperf,
        drvs.linuxHeaders,
        drvs.bash,
      ],

      extraEnv = {
        # LDFLAGS_FOR_BUILD = ["-static","--static"],
        CC_FOR_BUILD = ["clang", "-static", "--static"]
      },
      preConfigurePhase =[
        m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/src/arch-gperf-generate"%
      ]
    }
}
