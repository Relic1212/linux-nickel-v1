{
  lib,
  pythonMarkupsafe | lib.SetuptoolPackage = {
    #name = "python-markupsafe",
    singleSource = {
      uri = "https://github.com/pallets/markupsafe/archive/refs/tags/2.1.5.tar.gz",
      sha256sum = "307f63295d17f178b7d3af5968fb828e34086d5d66fec505b630a1e5f5b3328b",
    },
  }
}
