{
  lib,
  pythonElftools | lib.SetuptoolPackage
    = {
      name = "python-elftools",
      singleSource = {
        uri = "https://github.com/eliben/pyelftools/archive/refs/tags/v0.31.tar.gz",
        sha256sum = "24815cbfff9c5f68f5268983f55d969540a087bfdaa73c93f1a88e2a771f80f1",
      }
    }
}
