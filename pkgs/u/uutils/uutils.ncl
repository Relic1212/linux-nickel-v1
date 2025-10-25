{
  lib,
  drvs,
  uutils | lib.CargoPackage =
    let j = import "./uutils-packages.json"
    in
    let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
    in

    {
      nonCrateSourceInputs = [
        {
          src = {
            uri = "https://github.com/uutils/coreutils/archive/refs/tags/0.3.0.tar.gz",
            sha256sum = "422b4bab88d6a4da9eabcc947b4e8e0c7fbd123c88700f8750da45910bfb03b6"
          }
        }
      ],

      separateBuildDir = false,
      crates = _crates,

      options = {
        progs = std.string-split " " "arch base32 base64 basename basenc cat chgrp chmod chown chroot cksum comm cp csplit cut date dd df dir dircolors dirname du echo env expand expr factor false fmt fold groups hashsum head hostid hostname id install join kill link ln logname ls mkdir mkfifo mknod mktemp more mv nice nl nohup nproc numfmt od paste pathchk pr printenv printf ptx pwd readlink realpath rm rmdir seq shred shuf sleep sort split stat stty sum sync tac tail tee test timeout touch tr true truncate tsort tty uname unexpand uniq unlink vdir wc whoami yes"
      },
      releaseFlags = [
        "--profile release-fast",
      ],
      extraCargoFlags = [
        #"--features=feat_os_unix_musl",
        "--features \"arch base32 base64 basename basenc cat chgrp chmod chown chroot cksum comm cp csplit cut date dd df dir dircolors dirname du echo env expand expr factor false fmt fold groups hashsum head hostid hostname id install join kill link ln logname ls mkdir mkfifo mknod mktemp more mv nice nl nohup nproc numfmt od paste pathchk pr printenv printf ptx pwd readlink realpath rm rmdir seq shred shuf sleep sort split stat stty sum sync tac tail tee test timeout touch tr true truncate tsort tty uname unexpand uniq unlink vdir wc whoami yes\"",
        # "--no-default-features",

        # "-p uu_wc",
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

      #       buildPhase = [
      # "make PREFIX=/usr PROFILE=release CARGOFLAGS=\"--offline --target x86_64-unknown-linux-musl\" SKIP_UTILS=\"stdbuf\" SELINUX_ENABLED= V=1 UTILS=\"arch base32 base64 basename basenc cat chgrp chmod chown chroot cksum comm cp csplit cut date dd df dir dircolors dirname du echo env expand expr factor false fmt fold groups hashsum head hostid hostname id install join kill link ln logname ls mkdir mkfifo mknod mktemp more mv nice nl nohup nproc numfmt od paste pathchk pr printenv printf ptx pwd readlink realpath rm rmdir seq shred shuf sleep sort split stat stty sum sync tac tail tee test timeout touch tr true truncate tsort tty uname unexpand uniq unlink vdir wc whoami yes\" MULTICALL=y"
      #       ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 target/%{target}/release-fast/coreutils ${DEST}/usr/bin",
      ]

      #   std.array.map (fun m => "%{m} DESTDIR=${DEST} install") buildPhase
      ,

      #   biDrvs = [
      #     drvs.gnumake,
      #   ]
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
