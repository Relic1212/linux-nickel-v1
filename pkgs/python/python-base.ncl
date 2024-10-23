let lib = import "../../nickellib/lib.ncl"
in
let pythonBaseBase |lib.AutotoolsPackage
  = {
    stage | default = lib.AutotoolsPackage.stage,
    name = if stage == "final" then "python" else "python-stage-%{ std.to_string stage}",
    sourceInputs = [
      {
        src = {
          uri = "https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tar.xz",
          sha256sum = "f6d419a6d8743ab26700801b4908d26d97e8b986e14f95de31b32de2b0e79554",
        }
      }
    ],
    makeArgs = ["LINKFORSHARED=''"] @ (lib.AutotoolsPackage.makeArgs),
    extraEnv = {
      LINKFORSHARED = "''"
    },
    configureFlags =
      (lib.AutotoolsPackage.configureFlags)
      @ [
        "--disable-profiling",
        "--disable-pystats",
        "--without-ensurepip",
        "--build=x86_64-unknown-linux-gnu",
        "--host=x86_64-unknown-linux-gnu",
        "--target=x86_64-unknown-linux-gnu",
      ]
  }
  in
pythonBaseBase