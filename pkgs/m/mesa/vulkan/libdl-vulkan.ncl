{
  lib,
  drvs,
  libdl_vulkan | lib.Package = {

    singleSource = {
      uri = "/home/user/Projects/test-static-linking/vulkan/dl2.c",
      # uri = "/home/user/Projects/test-static-linking/vulkan/libdl_vulkan.a",
      sha256sum = "36d9366fae076e1e34471f87d09c252a2d66416210dbe28a6f42005e88975b6d"
    },
    buildPhase = [
      "clang -g -c ${SRC}/dl2.c -o dl.c.o",
      "llvm-ar rcs libdl_vulkan.a dl.c.o",
      "llvm-ranlib libdl_vulkan.a",
      "llvm-objcopy --redefine-sym=dlopen=stub_dlopen libdl_vulkan.a",
      "llvm-objcopy --redefine-sym=dlsym=stub_dlsym libdl_vulkan.a",
      "llvm-objcopy --redefine-sym=dladdr=stub_dladdr libdl_vulkan.a",
      "llvm-objcopy --redefine-sym=dlopen_vulkan=dlopen libdl_vulkan.a",
      "llvm-objcopy --redefine-sym=dlsym_vulkan=dlsym libdl_vulkan.a",
      "llvm-objcopy --redefine-sym=dladdr_vulkan=dladdr libdl_vulkan.a",
    ],

    installPhase = [
      "install -d -m755 ${DEST}/usr/lib",
      "install -m755 libdl_vulkan.a ${DEST}/usr/lib",
    ],
    enableCcache = false,
    muslProvider,
    biDrvs = [
      drvs.llvm,
      muslProvider,
      drvs.vulkanHeaders,
    ]
  }
}
