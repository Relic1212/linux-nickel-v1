{
  lib,
  drvs,
  ruby | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://cache.ruby-lang.org/pub/ruby/4.0/ruby-4.0.5.tar.gz",
      sha256sum = "7d6149079a63f8ae1d326c9fa65c6019ba2dc3155eae7b39159817911c88958e",
    },
    extraConfigureFlags = [
      "--with-rdoc=''",
      "--disable-install-doc",
      "--disable-install-rdoc",
      "--disable-install-capi",
      "--with-static-linked-ext",
    ],
    pDrvs = [
      drvs.libyaml,
    ]
  }
}
