{
  lib,
  drvs,
  selinuxRefpolicy | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/SELinuxProject/refpolicy/archive/refs/tags/RELEASE_2_20260616.tar.gz",
      sha256sum = "f95eb4e677745518d980618f1eb9ca880721e2f5102ad33dacbb55c997e14e33",
    },
    sourceInputs = [
      { src = singleSource, },
      {
        src = {
          uri = "https://github.com/SELinuxProject/refpolicy/commit/7426d2180c573492391148adf2217b2a81fec5e9.patch",
          sha256sum = "f55965eea2192bf1d8cecc15b9e9254522cdd2af565cd6686c48fa01fc803373"
        },
      },
    ],
    # enableParallel = false,
    makeArgs,
    extraMakeArgs = [
      "NAME=targeted",
      "TYPE=standard",
      # "LOCAL_ROOT=${DEST}",
      "DESTDIR=${DEST}",
      "SBINDIR=/usr/bin",
      "tc_sbindir=/usr/bin",
    ],
    extraMakeInstallArgs = ["PREFIX=/usr"] @ extraMakeArgs,
    makeInstallTargets = ["install", "install-src"],
    preConfigurePhase = [
      "patch -p1 < 7426d2180c573492391148adf2217b2a81fec5e9.patch",
      "rm policy/modules/services/uwimap.*",
      m%"sed -i 's|user_u|unconfined_u|g' config/appconfig-standard/seusers"%,
      m%"sed -i 's|root:root|root:unconfined_u|g' config/appconfig-standard/seusers"%,
    ],
    buildPhase = [
      # "mkdir -p policy/modules/local",
      lib.functions.appendFile "policy/modules/system/init.fc" (import "localmod.fc" as 'Text),
      # lib.functions.writeFile "policy/modules/local/metadata.xml" "<summary>local</summary>",
      # lib.functions.writeFile "policy/modules/admin/localmod.te" (import "localmod.te" as 'Text),
      # lib.functions.writeFile "policy/modules/admin/localmod.if" (import "localmod.if" as 'Text),

      # "mkoverlay /usr/bin",
      # "mv /usr/bin/semodule /usr/bin/semodule.real",
      # lib.functions.writeFile "/usr/bin/semodule" (import "semodule.sh" as 'Text),
      # "chmod +x /usr/bin/semodule",
      #   "make conf",
      "make %{std.string.join " " makeArgs} bare",
      "make %{std.string.join " " makeArgs} conf",
      "make %{std.string.join " " makeArgs} all",
      "make %{std.string.join " " makeArgs} install",
      "make %{std.string.join " " makeArgs} install-headers",
      "make %{std.string.join " " makeArgs} install-appconfig",
      # "make %{std.string.join " " makeArgs} install-src",
      # "make %{std.string.join " " makeArgs} validate",
      lib.functions.writeFile "${DEST}/etc/selinux/semanage.conf" (import "semanage.conf" as 'Text),
      (
        let config = [
          "SELINUX=permissive",
          "SELINUXTYPE=targeted",
        ]
        in std.string.join "\n" (std.array.map (fun c => "printf \"%{c}\\n\" >> ${DEST}/etc/selinux/config") config)
      ),
      # "for f in $(find ${DEST} -name '*.pp'); do",
      # "echo \"f=$f\"",
      # "mkdir -p $DEST/var/lib/selinux/final/targeted/contexts/files/",
      "semodule --verbose --disable_dontaudit -p ${DEST} -s targeted --noreload --install $(find ${DEST} -name '*.pp')",
      # "done",
      # m%"semodule --verbose --disable_dontaudit -p ${DEST} --noreload --build"%,
      m%"semodule --verbose --disable_dontaudit -p ${DEST} -s targeted --noreload --build"%,
      # m%"semodule --verbose --disable_dontaudit -p ${DEST} -s refpolicy --noreload --build"%,
      #   "cp policy/modules.conf .",
      #   "exit 0",
      #     "make DESTDIR=$DEST install",
      # "echo 'preConfigurePhase done'",
      # m%"sed -i 's|user_u|unconfined_u|g' ${DEST}/etc/selinux/targeted/seusers"%,
      # m%"sed -i 's|root:root|root:unconfined_u|g' ${DEST}/etc/selinux/targeted/seusers"%,    
    ],
    # buildPhase = [],
    installPhase = [],

    biDrvs = [
      drvs.m4,
      drvs.pythonFull,
      drvs.selinux,
      drvs.gawk,
      drvs.basefiles,
      drvs.mkoverlay,
    ],
  },
  seRoot | lib.MakePackage = {
    biDrvs = [
      drvs.m4,
      drvs.pythonSelinux,
      drvs.selinux,
      drvs.gawk,
      drvs.selinuxRefpolicy,
      drvs.mkoverlay,
      drvs.selinuxSetools,
    ],
  }
}
