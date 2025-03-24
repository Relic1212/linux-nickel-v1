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
