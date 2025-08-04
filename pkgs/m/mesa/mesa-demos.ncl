{
    lib,
    drvs,
    mesaDemos| lib.MesonPackage = {
        singleSource = {
            uri = "https://archive.mesa3d.org/demos/mesa-demos-9.0.0.tar.xz",
            sha256sum = "3046a3d26a7b051af7ebdd257a5f23bfeb160cad6ed952329cdff1e9f1ed496b"
        },

    options = {
        glx | default = true,
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],},
        
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
      # drvs.wayland,
      # drvs.waylandProtocols,
      drvs.linuxHeaders,
      drvs.m4,
      drvs.git,
      drvs.pyyaml,
      drvs.llvmFull,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.glu,
    ] @ (if options.glx then [
        drvs.mesaGlx,

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

    ] else [

        drvs.mesa2,
    ]) ,
    }
}

&
    (let glu_src = { uri = "https://archive.mesa3d.org/glu/glu-9.0.3.tar.xz", sha256sum = "bd43fe12f374b1192eb15fe20e45ff456b9bc26ab57f0eee919f96ca0f8a330f" } in 

 {lib,
    drvs,
    glu| lib.MesonPackage = {
        singleSource = glu_src,

    options = {
        glx | default = true,
    },
    extraMesonArgs = [
        "-Dgl_provider=gl"
    ],
        
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
      # drvs.wayland,
      # drvs.waylandProtocols,
      drvs.linuxHeaders,
      drvs.m4,
      drvs.git,
      drvs.pyyaml,
      drvs.llvmFull,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.wayland,
      drvs.waylandProtocols,
    ] @ (if options.glx then [
        drvs.mesaGlx,

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

    ] else [

        drvs.mesa2,
    ]) ,
    }
 })