{
  lib,
  pkgs,
  dash | lib.AutotoolsPackage
    = {
      buildEnv,
      singleSource = {
        uri = "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.12.tar.gz",
        sha256sum = "6a474ac46e8b0b32916c4c60df694c82058d3297d8b385b74508030ca4a8f28a",
      },
      extraMakeArgs = [
        "CFLAGS_FOR_BUILD=\"-static --static\""
      ],
    },
  dashAarch64 =
    dash
    & {
      buildEnv,
      # extraConfigureFlags = [
      #   "ac_cv_func_strsignal='yes'",
      #   "ac_cv_func_killpg='yes'",
      #   "ac_cv_func_strtod='yes'",
      #   "--host=aarch64-unknown-linux-musl",
      #   "--target=aarch64-unknown-linux-musl",

      # ],
      extraConfigureFlagsByField = {
        ac_cv_func_strsignal = "'yes'",
        ac_cv_func_killpg = "'yes'",
        ac_cv_func_strtod = "'yes'",
        "--host" = "aarch64-unknown-linux-musl",
        "--target" = "aarch64-unknown-linux-musl",
      },
      buildInputs = pkgs.busyboxAarch64.buildInputs,
      buildEnv.TARGET = pkgs.busyboxAarch64.buildEnv.TARGET,
      # buildEnv.CPP=["clang-cpp","-target aarch64-unknown-linux-musl"],
      buildEnv.CPP = ["clang", "--target=aarch64-unknown-linux-musl", "--sysroot=/aarch64-unknown-linux-musl", "-E"],

      buildEnv.EXTRA_CPPFLAGS = [
        "-I/aarch64-unknown-linux-musl/usr/include/",
        "-nostdinc",
      ],

      buildEnv.EXTRA_CFLAGS = [
        "-I/aarch64-unknown-linux-musl/usr/include/"
      ],

      buildEnv.EXTRA_LDFLAGS = [
        "--verbose",
        "-nostdlib",
        "--rtlib=compiler-rt",
        #"-Wl,-as-needed",
        "-L/aarch64-unknown-linux-musl/usr/lib/linux",
        "-L/aarch64-unknown-linux-musl/usr/lib",

        # #  "-l:clang_rt.crtbegin-aarch64.o",
        # # "-l:clang_rt.crtend-aarch64.o",
        # "-l:libclang_rt.builtins-aarch64.a",
        # "-l:libc.a"
        #  "-lclang_rt.crtbegin-aarch64.o -Wl,--start-group -l:libclang_rt.builtins-aarch64.a -l:libunwind.a  -lc -Wl,--end-group -lclang_rt.crtend-aarch64.o",
        #              "/usr/bin/ld.lld" --sysroot=/aarch64-unknown-linux-musl -EL --hash-style=gnu --eh-frame-hdr -m aarch64linux -static -o a.out /aarch64-unknown-linux-musl/usr/lib/crt1.o /aarch64-unknown-linux-musl/usr/lib/crti.o crtbeginT.o -L/aarch64-unknown-linux-musl/usr/lib -as-needed /tmp/conftest-243c77.o --start-group /usr/lib/clang/19/lib/aarch64-unknown-linux-musl/libclang_rt.builtins.a -l:libunwind.a -lc --end-group crtend.o /aarch64-unknown-linux-musl/usr/lib/crtn.o

        #  "/usr/bin/ld.lld" --sysroot=/aarch64-unknown-linux-musl -EL --hash-style=gnu --eh-frame-hdr -m aarch64linux -static -o conftest -L/aarch64-unknown-linux-musl/usr/lib -as-needed /tmp/conftest-880272.o
      ],
      # buildEnv.LD= [ "clang","--target=%{buildEnv.TARGET}", "--sysroot=/%{buildEnv.TARGET}"],
    }
}
