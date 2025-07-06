{
  lib,

  tzcode,

  tzdata | lib.MakePackage = {
    singleSource = {
      uri = "https://data.iana.org/time-zones/releases/tzdata2024b.tar.gz",
      sha256sum = "70e754db126a8d0db3d16d6b4cb5f7ec1e04d5f261255e4558a67fe92d39e550"
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = tzcode.singleSource
      }
    ],
    preConfigurePhase = [
      m%"
            sed -i 's@sbin@bin@g' ${SRC}/Makefile
            "%
    ],
    postInstallPhase = [
      "cd ${DEST}/etc",
      "rm localtime",
      "ln -s /usr/share/zoneinfo/Europe/Stockholm localtime",
    ]
  }
}
& {
  lib,

  tzdb | lib.MakePackage = {
    singleSource = {
      uri = "https://data.iana.org/time-zones/releases/tzdb-2024b.tar.lz",
      sha256sum = "22674a67786d3ec1b0547305904011cb2b9126166e72abbbea39425de5595233"
    }
  }
}
& {
  lib,

  tzcode | lib.MakePackage = {
    singleSource = {
      uri = "https://data.iana.org/time-zones/releases/tzcode2024b.tar.gz",
      sha256sum = "5e438fc449624906af16a18ff4573739f0cda9862e5ec28d3bcb19cbaed0f672"
    }
  }
}
