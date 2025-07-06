{
  lib,
  muslShared,
  fish,
  basefiles,
  ripgrep,
  ncurses,
  nasm,
  dockerfile,
  tinycc,
  gccExp,
  binutilsExp,
  grub2,
  libburn,
  libisofs,
  libisoburn,
  llvmFull,

  ociImage | lib.MakePackage = {
    llvmProvider = lib.singleBiMap llvmFull,
    biDrvs =
      lib.biMap [
        muslShared,
        fish,
        basefiles,
        ripgrep,
        ncurses,
        nasm,
        dockerfile,
        tinycc,
        gccExp,
        binutilsExp,
        grub2,
        libburn,
        libisofs,
        libisoburn,
      ],
  },
  dockerfile | lib.Package = {
    buildPhase = [
      m%"
			printf "
			FROM scratch
			ADD . /

			" > ${DEST}/Dockerfile
			"%
    ]
  }
}
