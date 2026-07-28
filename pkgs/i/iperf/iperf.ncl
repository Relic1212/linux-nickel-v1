{
  lib,
  drvs,
  iperf | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/esnet/iperf/archive/refs/tags/3.21.tar.gz",
      sha256sum = "dd289b6700d3bc33eda7fa3ce6db217d6ca42239edbcb2e7f152bf7bf5c8a5aa",
    }
  }
}
