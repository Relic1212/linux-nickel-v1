{
  lib,
  drvs,
  glmWf | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/g-truc/glm/archive/33b4a621a697a305bc3a7610d290677b96beb181.zip",
      sha256sum = "79263e9526124b5b57c943f53e5e55b3e635aa9037f2a6326cd3193bba9816ec",
    }
  }
}
