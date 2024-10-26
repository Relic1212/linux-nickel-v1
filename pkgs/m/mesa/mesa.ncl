{
  lib,
  pkgs,
  mesa | lib.MesonPackage
    = {
      name = "mesa",
      singleSource = {
        uri = "https://archive.mesa3d.org/mesa-24.0.4.tar.xz",
        sha256sum = "90febd30a098cbcd97ff62ecc3dcf5c93d76f7fa314de944cfce81951ba745f0",
      },
      patches = [
        {
          file = "mesa-bb6a55b75b89fdd65d425b9f97c8cdec9a4703ad-static.patch",
          sha256sum = "9ae89539149379f36b0126a66b649e0e95e9a602dea416d73f447af53625d3ce"
        }
      ],
      biPkgs = [
        pkgs.libelf,
        pkgs.libdrm,
        pkgs.zlibNg,
        pkgs.pythonMako,
        pkgs.pythonPackaging,
        pkgs.pythonMarkupsafe,
        pkgs.libpciaccess,
        pkgs.libffi,
        pkgs.bison,
        pkgs.flex,
        pkgs.wayland,
        pkgs.waylandProtocols,
        pkgs.linuxHeaders,
        pkgs.m4
      ],
      extraMesonArgs = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        "-Dgallium-nine=false",
        "-Ddri3=disabled",
        "-Dopengl=false",
        "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
        "-Dllvm=disabled",
        "-Dplatforms='wayland'",
        "-Dcpp_rtti=false",
        "-Dshared-glapi=enabled",
        "-Dgbm=enabled",
        "-Dzstd=disabled",
        "-Dzlib=enabled",
        "-Dglvnd=false",
        "-Dvulkan-drivers=",
        "-Dshader-cache=disabled",
        "-Dexpat=disabled",
        "-Dvideo-codecs=''",
        "-Dtools=''",
        "-Degl=enabled",
        "-Dglx-read-only-text=true",
        "-Dgallium-xa=disabled",
        "-Dgallium-vdpau=disabled",
        "-Dgallium-va=disabled",
        "-Dgallium-opencl=disabled",
        "-Dimagination-srv=false",
        "-Dglx=disabled",
        "-Dopencl-spirv=false",
        "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=drm",
      ],
      preConfigurePhase = [
        m%"
          sed -i 's@main()@print()@g' ${SRC}/bin/install_megadrivers.py
          sed -i 's@def print()@def main()@g' ${SRC}/bin/install_megadrivers.py

          for f in $(find ${SRC} -type f -name meson.build );
              do sed -i 's@shared_library@library@g' $f;
          done

          "%
      ],
    }
}
