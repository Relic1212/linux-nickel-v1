{
  lib,
  clangCc,

  uutils | lib.CargoPackage =
    let j = import "./uutils/uutils-packages.json"
    in
    let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
    in

    {
      nonCrateSourceInputs = [
        {
          src = {
            uri = "https://github.com/uutils/coreutils/archive/refs/tags/0.0.27.tar.gz",
            sha256sum = "3076543a373c8e727018bd547cc74133f4a6538849e4990388f2bbea9a9aff6b"
          }
        }
      ],
      biDrvs =
        lib.biMap [
          # clangCc,
        ],

      separateBuildDir = false,
      crates = _crates,
      extraCargoFlags = [
        "--features=feat_os_unix_musl"
      ],

      # crates.uuhelp_parser."0.0.27".sha256sum = "1",
      preConfigurePhase = [
        m%"
        for d in $(ls  ${SRC}/vendor); do
          if [ -e ${SRC}/vendor/${d}/download ]; then
            mv  ${SRC}/vendor/${d}/download  ${SRC}/vendor/${d}/download.tar.gz
            tar -xf ${SRC}/vendor/${d}/download.tar.gz --strip-components=1 -C ${SRC}/vendor/${d}/
            echo '{"package":"'"$(sha256sum ${SRC}/vendor/${d}/download.tar.gz|cut -d ' ' -f1)"'","files":{}}' >  ${SRC}/vendor/${d}/.cargo-checksum.json
          fi
        done
        "%,
        "mkdir -p ${SRC}/.cargo",
        m%"
        echo "

        [source.crates-io]
        replace-with = \"vendored-sources\"

        [source.vendored-sources]
        directory = \"vendor\"


        " >> ${SRC}/.cargo/config.toml
        "%,
        "export CARGO_HOME=${SRC}/.cargo",
      ],
      target,
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 target/%{target}/release/coreutils ${DEST}/usr/bin",
      ]
    },

  uutilsSymlinks | lib.Package = {
    installPhase =
      let links = [
        "[",
        "arch",
        "b2sum",
        "b3sum",
        "base32",
        "base64",
        "basename",
        "basenc",
        "cat",
        "chgrp",
        "chmod",
        "chown",
        "chroot",
        "cksum",
        "comm",
        "cp",
        "csplit",
        "cut",
        "date",
        "dd",
        "df",
        "dir",
        "dircolors",
        "dirname",
        "du",
        "echo",
        "env",
        "expand",
        "expr",
        "factor",
        "false",
        "fmt",
        "fold",
        "groups",
        "hashsum",
        "head",
        "hostid",
        "hostname",
        "id",
        "install",
        "join",
        "kill",
        "link",
        "ln",
        "logname",
        "ls",
        "md5sum",
        "mkdir",
        "mkfifo",
        "mknod",
        "mktemp",
        "more",
        "mv",
        "nice",
        "nl",
        "nohup",
        "nproc",
        "numfmt",
        "od",
        "paste",
        "pathchk",
        "pr",
        "printenv",
        "printf",
        "ptx",
        "pwd",
        "readlink",
        "realpath",
        "rm",
        "rmdir",
        "seq",
        "sha1sum",
        "sha224sum",
        "sha256sum",
        "sha3-224sum",
        "sha3-256sum",
        "sha3-384sum",
        "sha3-",
        "512sum",
        "sha384sum",
        "sha3sum",
        "sha512sum",
        "shake128sum",
        "shake256sum",
        "shred",
        "shuf",
        "sleep",
        "sort",
        "split",
        "stat",
        "stty",
        "sum",
        "sync",
        "tac",
        "tail",
        "tee",
        "test",
        "timeout",
        "touch",
        "tr",
        "true",
        "truncate",
        "tsort",
        "tty",
        "uname",
        "unexpand",
        "uniq",
        "unlink",
        "vdir",
        "wc",
        "whoami",
        "yes",
      ]
      in
      [
        "install -d -m0755 ${DEST}/usr/bin",
        "cd ${DEST}/usr/bin",
      ]
      @ (std.array.map (fun x => "ln -s /usr/bin/coreutils %{x}") links)
  }
}
