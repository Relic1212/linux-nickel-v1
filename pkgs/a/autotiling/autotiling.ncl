{
  lib,

  autotiling | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/nwg-piotr/autotiling/archive/refs/tags/v1.9.3.tar.gz",
      sha256sum = "3270a28de977f375c80984ef50f7433cb03cfdf198b079ae9c80d1513f0e9176"
    }
  }
}
& {
  lib,

  i3ipcPython | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/altdesktop/i3ipc-python/archive/9de8e885536bf611c96cc7c8ea0b2f19dd40f4f2.zip",
      sha256sum = "55f48ad642c4838cb8ae4b599e4048090c7d0f53d1668340dd2ff4330ea1b363"
    }
  }
}
