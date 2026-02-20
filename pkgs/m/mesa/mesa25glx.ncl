{
  lib,
  drvs,
  mesa2,
  mesaExp,
  mesaGlx =
    mesaExp
    & {

      extraMesonArgs | priority 2 = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        #   "-Dgallium-nine=false",
        #   "-Ddri3=disabled",
        "-Dopengl=true",
        "-Dgallium-drivers=radeonsi,virgl,i915,crocus,iris",
        "-Dplatforms='wayland,x11'",
        "-Dcpp_rtti=false",
        #   "-Dshared-glapi=enabled",
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
        #   "-Dgallium-xa=disabled",
        #   "-Dgallium-vdpau=disabled",
        #   "-Dgallium-va=disabled",
        #   "-Dgallium-opencl=disabled",
        "-Dimagination-srv=false",
        "-Dglx=dri",
        #   "-Dopencl-spirv=false",
        #   "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=wayland",
        "-Dlegacy-wayland='bind-wayland-display'",

        #   "-Dintel-clc=enabled",
        "-Dllvm=enabled",
        "-Dunversion-libgallium=true",
        "-Dradv-build-id=eacebefb-54f9-4b7f-9ebe-3f9c33ae41da",
        "-Dradeonsi-build-id=facebefb-54f9-4b7f-9ebe-3f9c33ae41da",
        "-Damd-use-llvm=false",
      ],

      patches | priority 1 =
        mesa2.patches
        @ [
          {
            sha256sum = "f224c21164f80f9766df0ba2531b11c6da43a6d61178e1e5e55da90cd2c6858c",
            file = "mesa-glx-no-dups.patch"
          }
        ],
      biDrvs | priority 1 =
        mesa2.biDrvs
        @ [
          # drvs.wayland,
          # drvs.waylandProtocols,
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
          # drvs.xwayland,
          drvs.libxkbfile,
          drvs.openssl,
          drvs.xcbUtilWm,
          drvs.xcbUtilErrors,
          drvs.libxext,
          drvs.libxf86vm,
          drvs.libxrandr,
        ]
    },
  mesaGlxEpoxy =
    mesaGlx
    & {
      postInstallPhase | priority 1 =
        let syms = (let s = import "libgl.syms" as 'Text in std.string.split "\n" s) in
        std.array.map
          (fun s => "objcopy --redefine-sym %{s}=libGL__%{s} ${DEST}/usr/lib/libGL.a"
          )
          syms
    }
}
