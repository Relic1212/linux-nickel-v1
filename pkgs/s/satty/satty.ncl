{
  lib,
  drvs,
  satty | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/Satty-org/Satty/archive/refs/tags/v0.20.1.tar.gz",
      sha256sum = "86e85e8abdcfee925f0b95d424bd9eed9ad78aeb537707132e77ccb63133ac97",
    },
    crates = lib.functions.filterCrates (import "satty-crates.json"),

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--allow-multiple-definition",
        # m%"$(for l in $(pkg-config --libs --static egl epoxy);do printf " -C link-arg=$l ";done)"%,
      ],
    },
    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=-Wl,--allow-multiple-definition",
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        "-C link-arg=-lc++",
        "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        m%"$(for l in $(pkg-config --libs --static glesv2 egl epoxy);do printf " -C link-arg=$l ";done)"%,
      ],
    },

    configurePhase = [
      lib.functions.writeFile "${SRC}/dlopen.c" (import "satty_dlopen.c" as 'Text),
      "cat >>${SRC}/dlopen.c << 'EOF'\n%{(import "constructor.c" as 'Text)}\nEOF\n",
      "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],
    linkSelfContained = "no",

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,

    pDrvs = [
      drvs.libadwaita,
    ]
  }
}
