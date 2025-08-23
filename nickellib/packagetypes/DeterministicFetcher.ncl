{
  drvs,
  lib = {
    Package,
    DeterministicFetcher =
      Package
      & {
        deterministicFetcher | force = true,
        # outputFile | String | default ="",
        # outputSha256sum | String | default ="",
      }
  }
}
