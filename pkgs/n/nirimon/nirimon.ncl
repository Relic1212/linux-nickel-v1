{
  lib,
  drvs,
  nirimon | lib.Package = {
    singleSource = {
      uri = "https://github.com/stepbrobd/nirimon/archive/refs/tags/2026.519.0.tar.gz",
      sha256sum = "5f5e2f5e1c8df3bc7d8baa5851ff94fb625c8071d196c20c3af49593cf7f4903",
    },
    sourceInputs = [
      { src = singleSource, },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/charmbracelet/bubbles/@v/v1.0.0.zip",
          sha256sum = "b245dafe1f179d4f0ce17b950ce12ac884ab0c7f69fd2d2f282be68e373d5468"
        }
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/charmbracelet/bubbletea/@v/v1.3.10.zip",
          sha256sum = "8afc524c11d18878b0ac3426fd3318fdf05ad576e65883c597996296c1b27117"
        }
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/charmbracelet/lipgloss/@v/v1.1.0.zip",
          sha256sum = "22512fd8c211302255bb6f57d8018eed9b8d8f6dd51310512901240bde9b061a"
        }
      },
      {
        src = {
          uri = "https://proxy.golang.org/golang.org/x/term/@v/v0.43.0.zip",
          sha256sum = "0d12dd77f2c620f236e59421d604f6bcd1f9212a4083a1c0ec13425c67bc6e81"
        }
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/atotto/clipboard/@v/v0.1.4.zip",
          sha256sum = "d67b2c36c662751309fd2ec351df3651584bea840bd27be9a90702c3a238b43f"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/charmbracelet/x/ansi/@v/v0.11.7.zip",
          sha256sum = "1d52a11e3ddfeabe350df8b1a5ee7a8660ac6903ae3a9f1031d9668384d59f6a"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/charmbracelet/x/cellbuf/@v/v0.0.15.zip",
          sha256sum = "2c5c421edef869c7f4b7b3fa29530a66897134764d95a750eed59ed5886d84f7"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/muesli/termenv/@v/v0.16.0.zip",
          sha256sum = "ba02d3ebd9c1d87e2c2133b1f2bb61a7001b3765196e8016029ce9fe54c5c0fc"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/rivo/uniseg/@v/v0.4.7.zip",
          sha256sum = "b995e4aa0cc1e5779cc61138ac925cb8c1e963e40c80e4b93ee8553812ebb792"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/charmbracelet/x/term/@v/v0.2.2.zip",
          sha256sum = "0452a430f7e6882393f81ba19a70a63709960acb9743e1199a7b04d908e6b506"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/muesli/ansi/@v/v0.0.0-20230316100256-276c6243b2f6.zip",
          sha256sum = "59c0d420908d51df3c701510337fbe42bfb4d48fcc5f490b5eb2f36fc25f91b9"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/muesli/cancelreader/@v/v0.2.2.zip",
          sha256sum = "f0654e7f8f8a49b02ff10a75ccaa0eb08a65aaacbc45f5ba93305276e2ac7f61"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/mattn/go-runewidth/@v/v0.0.23.zip",
          sha256sum = "587ac0cc4bb87a6bbabfa48e4a4f646c3b6b08deac7c99dd43e8835dd8156b67"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/golang.org/x/sys/@v/v0.44.0.zip",
          sha256sum = "f1fa1052808e6bd6eb9c5372c053b2370a582532fac5d6a4600e7a6fab190ff3"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/clipperhouse/displaywidth/@v/v0.11.0.zip",
          sha256sum = "27830c91cdfb2a648748db21f7a2734dcb50d21c620edde51d488ba4e7967e3d"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/clipperhouse/uax29/v2/@v/v2.7.0.zip",
          sha256sum = "67b1278f1ffb4e4d783a390e48fe7396864650138e785d4b4bfca5914333f761"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/lucasb-eyer/go-colorful/@v/v1.4.0.zip",
          sha256sum = "f2c9689fc5ca32b6ed1436bcce879b44e7b9d14f670681ab41974213f2acb217"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/charmbracelet/colorprofile/@v/v0.4.3.zip",
          sha256sum = "656472ff48f01a098418a31667f3253cf34e04d4e1cb6c1a0a80f76ad370b689"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/aymanbagabas/go-osc52/v2/@v/v2.0.1.zip",
          sha256sum = "939ebf2a5481f2172e1a5e0c318d05aef5b6d950a960556216c3da7879a927f8"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/mattn/go-isatty/@v/v0.0.22.zip",
          sha256sum = "aee31e550fcdffd1fc4b8e7e7fa8bb59aa4311f9c0b51893f8c6837f8c3f7f37"
        },
      },
      {
        src = {
          uri = "https://proxy.golang.org/github.com/xo/terminfo/@v/v0.0.0-20220910002029-abceb7e1c41e.zip",
          sha256sum = "b8f4270191e08e135e932dfe168769046a4268ec7f3892593b1d773b2c5fa4cf"
        },
      },
    ],
    separateBuildDir = false,
    extraEnv = {
      "GOROOT" = "/usr/lib/go",
      "HOME" = "/tmp/home",
    },
    preConfigurePhase =
      [
        "mkdir ${HOME}",
        "export GOPROXY=\"file:///tmp/workdir/build/goproxy,https://proxy.golang.org\"",
        # "export GOPROXY=direct",
        "mkdir ${BUILDDIR}/goproxy",
      ]
      @ (
        std.array.map
          (fun src =>
            let dest = std.string.replace "https://proxy.golang.org/" "" src.src.uri, fsrc = "/tmp/workdir/packed/%{src.src.sha256sum}/%{std.string.split "/" src.src.uri |>std.array.last}" in
            "UNZIPDIR=${BUILDDIR}/%{src.src.sha256sum}"
            ++ "\n"
            ++ "mkdir ${UNZIPDIR}"
            ++ "\n"
            ++ "(cd ${UNZIPDIR}/ && unzip %{fsrc})"
            ++ "\n"
            ++ "install -Dm0755 %{fsrc} ${BUILDDIR}/goproxy/%{dest}"
            ++ "\n"
            ++ "GOMOD=\"$(find ${UNZIPDIR} -name go.mod)\""
            ++ "\n"
            ++ "cp -v $(dirname ${GOMOD})/*.mod $(dirname ${BUILDDIR}/goproxy/%{dest})"
            ++ "\n"
            ++ "cp -v ${GOMOD} ${BUILDDIR}/goproxy/%{std.string.replace ".zip" ".mod" dest}"
          )
        #
          (std.array.drop_first sourceInputs)
        #
      ),
    buildPhase = [
      m%"go build -ldflags="-s -w -X main.Version=$(cat version.txt)""%,
    ],
    installPhase = [
      "install -Dm0755 nirimon ${DEST}/usr/bin/nirimon",
    ],
    biDrvs = [
      drvs.go_1_26,
    ]
  }
}
