Builds happen im `$TMPDIR/work`, where the following directories are special:

* `./build`
* `./src` 
* `./packed`
* `./patches`
* `./files`
* .`/out`

Stage 0 packages needed in chroot:
* Busybox
* Musl, gcc,linux-headers and binutils all combined

In chroot, build make, cmake, linux-headers, musl, llvm, busybox

TODO:

To support cross compilation:
* Separate `buildInputs` into `nativeBuildinputs` and `targetBuildinput`
* Install `targetBuildinputs` to `/sysroot-target`
* In `buildEnv`, also set `BUILD_*`, `HOST_*` and `*_FOR_BUILD`
* ~~set `PKGCONFIG*` in buildEnv~~ 
* Always pass `--target` to clang (at least to `CC`, `CPP`, `CXX` and `LD`) and figure out when to pass `--sysroot`. Maybe do this with a cc-wrapper.
* Always pass `--host` (and maybe `--target`?) to autotools
* Always use a cmake toolchain file
* Always use a meson cross file

Misc:
* ~~Bind rather than copy source tarballs~~
* Unpack sources once per source and bind-mount the unpacked tree read-only in workdir (so it does not have to be unpacked every time)
* ~~create a separate derivation for each sysroot (so only one is needed for every package with the same inputs)~~
* Figure out how to handle file conflicts
* set `KCONFIG_NOTIMESTAMP` for busybox
* ~~add ssl-certificates~~
* quickshell:  `QT_QPA_FONTDIR=/usr/share/fonts/TTF/` (http://git-nas03.anwsoft.com:8088/anw_si_a5/one_dime/-/issues/2)

Long run:
* Investigate use of clang in stage 0


Links:

* Clang cross: https://mcilloni.ovh/2021/02/09/cxx-cross-clang/
* https://maskray.me/blog/2021-03-28-compiler-driver-and-cross-compilation
