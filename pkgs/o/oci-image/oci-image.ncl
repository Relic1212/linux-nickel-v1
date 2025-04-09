{
  lib,
  drvs,
  ociImage | lib.MakePackage = {
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.muslShared,
      drvs.fish,
      drvs.basefiles,
      drvs.ripgrep,
      drvs.ncurses,
      drvs.nasm,
      drvs.dockerfile,
      drvs.tinycc,
      drvs.gccExp,
      drvs.binutilsExp,
      drvs.grub2,
                 drvs.libburn,
            drvs.libisofs,
            drvs.libisoburn,
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
