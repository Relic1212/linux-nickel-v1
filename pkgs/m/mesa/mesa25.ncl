{
  drvs,
  lib,
  _mesa250 | lib.MesonPackage = {
    # broken due to https://gitlab.freedesktop.org/mesa/mesa/-/commit/514df444ebc31b42707ffa10c1432d3c6e11ca60
    biDrvs = [
      drvs.libelf,
      drvs.libdrm,
      drvs.zlibNg,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.libpciaccess,
      drvs.libffi,
      drvs.bison,
      drvs.flex,
      drvs.linuxHeaders,
      drvs.m4,
      drvs.git,
      drvs.pyyaml,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.wayland,
      # drvs.waylandProtocols_1_39,
      drvs.waylandProtocols,
    ],
    llvmProvider = drvs.llvmFull,
    # 
    baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,
    extraMesonArgs = [
      "-Dgles1=disabled",
      "-Dxmlconfig=disabled",
      "-Dshared-llvm=disabled",
      "-Dgles2=enabled",
      "-Dgallium-nine=false",
      # "-Ddri3=disabled",
      "-Dopengl=true",
      "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
      "-Dplatforms='wayland'",
      "-Dcpp_rtti=false",
      "-Dshared-glapi=enabled",
      "-Dgbm=enabled",
      "-Dzstd=disabled",
      "-Dzlib=enabled",
      "-Dglvnd=disabled",
      "-Dvulkan-drivers=",
      "-Dshader-cache=disabled",
      "-Dexpat=disabled",
      "-Dvideo-codecs='all'",
      "-Dtools=''",
      "-Degl=enabled",
      "-Dglx-read-only-text=true",
      "-Dgallium-xa=disabled",
      "-Dgallium-vdpau=disabled",
      "-Dgallium-va=disabled",
      "-Dgallium-opencl=disabled",
      "-Dimagination-srv=false",
      "-Dglx=disabled",
      "-Dosmesa=false",
      "-Dvulkan-beta=false",
      "-Degl-native-platform=wayland",
      # "-Dintel-clc=disabled",
      "-Dllvm=enabled",
      # "-Dllvm=disabled",
    ],

    singleSource | priority 1 = {
      uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-25.1.7/mesa-mesa-25.1.7.tar.gz",
      sha256sum = "0ea146b22630839c01c4901b97d6885aec6e110ba4e45c493962cda001657db1",
    },

    extraEnv = {
      PATH = "/usr/libexec:${PATH}"
    },
    # patches | priority 1 = [
    #   {
    #     file = "0.patch",
    #     sha256sum = "f5b6671dae52941927aeb8d86155b2f5d4f3966651673942b29218864c4fd08f"
    #   },
    #   {
    #     sha256sum = "adfc47568f88f58887f9ef33b20fb9fbabaa4ee23213fb0a6e35146b0fe44665",
    #     file = "mesa-25.0-no-wl.patch",
    #   },
    #   {
    #     sha256sum = "613b5f0e3eab9d62398d623092a2aca11e69623cdd91cd29df8d411b05d45e76",

    #     file = "mesa-25.0-dont-split-gbm.patch"
    #   }
    # ],
    preConfigurePhase | priority 1 = [
      m%"
          sed -i 's@main()@print()@g' ${SRC}/bin/install_megadrivers.py
          sed -i 's@def print()@def main()@g' ${SRC}/bin/install_megadrivers.py

          for f in $(find ${SRC} -type f -name meson.build );
              do sed -i 's@shared_library@library@g' $f;
          done

          "%,
      m%"
          sed -i \
            "s@name_suffix : 'so',@name_suffix : 'a',@g" \
            ${SRC}/src/gallium/targets/dri/meson.build
          "%,
      m%"
          sed -i \
            "s@libname_suffix = 'so'@libname_suffix = 'a'@g" \
            ${SRC}/meson.build
          "%,
    ],
    postInstallPhase = [
      "sed -i 's@-pthread -lm@-pthread -lm -lgallium-25.0.0 -lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendOffloading -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMDebugInfoCodeView -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -lrt@g' ${DEST}/usr/lib/pkgconfig/egl.pc"
    ]
  },

  mesa25 = _mesa250,
}
