{
  lib,

  _pythonBase | lib.AutotoolsPackage = {
    stage | default = lib.AutotoolsPackage.stage,
    # name = if stage == "final" then "python" else "python-stage-%{ std.to_string stage}",
    baseName = "python",
    isStatic,
    singleSource = {
      uri = "https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tar.xz",
      sha256sum = "f6d419a6d8743ab26700801b4908d26d97e8b986e14f95de31b32de2b0e79554",
      # uri = "https://www.python.org/ftp/python/3.13.9/Python-3.13.9.tar.xz",
      # sha256sum = "ed5ef34cda36cfa2f3a340f07cac7e7814f91c7f3c411f6d3562323a866c5c66",
    },
    makeArgs = (if isStatic then ["LINKFORSHARED=''"] else []) @ (lib.AutotoolsPackage.makeArgs),
    extraEnv =
      if isStatic then
        {
          LINKFORSHARED = "''"
        }
      else
        {},
    # configureFlags =
    #   (lib.AutotoolsPackage.configureFlags)
    #   @
    extraConfigureFlags = [
      "--disable-profiling",
      "--disable-pystats",
      "--without-ensurepip",
      "--build=x86_64-unknown-linux-gnu",
      "--host=x86_64-unknown-linux-gnu",
      "--target=x86_64-unknown-linux-gnu",
    ]
  }
}
