{
  lib,
  drvs,
  nickelLang | lib.CargoPackage =
    let j = import "./nickel-lang/nickel-lang-crates-1.10.json"
    in
    let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
    in

    {
      singleSource = {
        # uri = "https://github.com/tweag/nickel/archive/refs/tags/1.9.0.tar.gz",
        # sha256sum = "c5c0000e6b1618921c1ce23dc90eefb482bdfe9f9716d4ef5cf24a3b99ec4c7d",

        uri = "https://github.com/tweag/nickel/archive/refs/tags/1.10.0.tar.gz",
        sha256sum = "15404075e20e45da3ff0e6ad54e94109c8fba2fbde1c2def00c1f3f4e8e3cbc8",
        #uri = "https://github.com/tweag/nickel/archive/c6122527061ec95a9a58c90a3a97ad867f038d64.zip",
        #sha256sum = "4f086944d4e41ef3c9e41391bb12514011266a35b8118a1863aae5316c297aa3"

        # uri = "https://github.com/tweag/nickel/archive/e4a1d4bde16fc97310ac841ed93bcbe10b42e20a.tar.gz",
        # sha256sum = "8dfb00107ff9e327b4c9222f6598a2142bf3ce6f3a1a5aaea2416a24da1e4cff"
      },

      patches = [
        {
          file = "7bcc0b7529a78807fa887d72a8528b87f8574e37.patch",
          sha256sum = "b1cf73f8f87cfcb3a9facca16c2bc4147ec74ab1384257ae68ab2199f1d79eee",
        }
      ],
      # release = false,
      crates = _crates,

      biDrvs = [
        drvs.pythonFull,
      ],
      target,
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 target/%{target}/release/nickel ${DEST}/usr/bin",
        "install -m0755 target/%{target}/release/nls ${DEST}/usr/bin",
      ]
    }
}
