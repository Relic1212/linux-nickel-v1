{
  lib,
  drvs,
  sway,
  libdl_vulkan,

  swayVulkan =
    sway
    & {
      debug = true,
      buildEnv._debug = true,
      extraMesonArgs | priority 1 = [
        "-Dwlroots:backends=drm,libinput",
        "-Dwlroots:color-management=enabled",
        "-Dwlroots:renderers=vulkan",
        "-Dgdk-pixbuf=enabled",
        "-Dtray=enabled",
        "-Dman-pages=enabled",
      ],

      # buildEnv.EXTRA_CFLAGS | priority 1=  [ 
      #   "-Wl,--whole-archive",
      #   "-l:libdl_vulkan.a",

      #   ],
      # buildEnv.EXTRA_LDFLAGS |priority 1 = sway.buildEnv.EXTRA_LDFLAGS @ [ "-Wl,-u,vkCreateSampler"],

      sourceInputs | priority 1 =
        sway.sourceInputs
        @ [
          {
            src = libdl_vulkan.singleSource,
            dest = "lib"
          }
        ],
      buildEnv.EXTRA_LDFLAGS | priority 1 =
        sway.buildEnv.EXTRA_LDFLAGS
        @ [
          "-L/tmp/workdir/src/lib",
          # "-Wl,--allow-multiple-definition",

          # "-Wl,--whole-archive",
          "-l:libdl_vulkan.a",
          "-l:libVkLayer_MESA_device_select.a",
          # "-Wl,--no-whole-archive",

          # "-l:libvulkan_radeon.a",
          # "-l:libvulkan_intel.a",
          # "-l:libvulkan_virtio.a",
          # "-Wl,--allow-multiple-definition",
          # "-Wl,--whole-archive",
          # "-lvulkan_radeon",
          # "-Wl,--no-whole-archive",
          "-Wl,-u,vk_common_GetPhysicalDeviceProperties2",
          "-Wl,-u,vk_common_CreateSamplerYcbcrConversion",
          "-Wl,-u,radv_CreateSampler",
          "-Wl,-u,radv_CreateDescriptorPool",
          "-Wl,-u,vk_common_CreateFramebuffer",
          "-Wl,-u,vk_common_CmdCopyBufferToImage",
          "-Wl,-u,radv_CmdCopyBufferToImage2",
          "$(pkg-config --libs --static vulkan_radeon)",
        ]
      # @ (
      #   std.string.split " " "-lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMSandboxIR -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendDirective -lLLVMFrontendAtomic -lLLVMFrontendOffloading -lLLVMObjectYAML -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMCGData -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoCodeView -lLLVMDebugInfoGSYM -lLLVMDebugInfoDWARF -lLLVMDebugInfoDWARFLowLevel -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -lrt -ldl -lm -lelf -leu -lz -ldrm_amdgpu -pthread -ldrm -lSPIRV-Tools-opt -lSPIRV-Tools -lSPIRV-Tools-link"
      # )
      ,

      preConfigurePhase | priority 1 =
        sway.preConfigurePhase
        @ [
          "clang  --verbose -g -c ${SRC}/lib/dl2.c -o ${SRC}/lib/dl.c.o",
          "llvm-ar rcs ${SRC}/lib/libdl_vulkan.a ${SRC}/lib/dl.c.o",
          "llvm-ranlib ${SRC}/lib/libdl_vulkan.a",
        ],
      baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,
      llvmProvider | priority 1 = drvs.llvmFullDebug,
      pDrvs | priority 1 = [
        drvs.seatd,
      ],
      biDrvs | priority 1 = [
        # drvs.libdl_vulkan,
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.mesaFull,
        drvs.spirvToolsDebug,
        drvs.glslangDebug,
        drvs.vulkanLoader,
        drvs.vulkanHeaders,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libelf,
        drvs.libpciaccess,
        drvs.libdrmDebug,
        drvs.libxkbcommon,
        drvs.pixman,
        drvs.eudev,
        drvs.libdisplayinfo,
        drvs.libinput,
        drvs.libffi,
        drvs.libevdev,
        drvs.mtdev,
        drvs.pango,
        drvs.fribidi,
        drvs.cairo,
        drvs.libpng,
        drvs.freetype,
        drvs.fontconfig,
        drvs.zlibNg,
        drvs.harfbuzz,
        drvs.glib,
        drvs.hwdata,
        drvs.linuxHeaders,

        # For optional features
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        # drvs.basu,
        drvs.lcms,
        drvs.scdoc,
        drvs.libxcursor,
        drvs.xorgMacros,
        drvs.xorgproto,
        drvs.xtrans,
        drvs.libxcb,
        drvs.xcbProto,
        drvs.libxau,
        drvs.libx11,
        drvs.libxrender,
        drvs.libxfixes,
        drvs.xcbRenderutil,
        drvs.libxfont2,
        drvs.libfontenc,
        drvs.libxcvt,
        drvs.libxshmfence,
        drvs.xwayland,
        drvs.libxkbfile,
        drvs.openssl,
        drvs.xcbUtilWm,
        drvs.xcbUtilErrors,
        drvs.libxext,
        drvs.libxf86vm,
        drvs.libxrandr,
        drvs.zstd,
      ],
    }
}
