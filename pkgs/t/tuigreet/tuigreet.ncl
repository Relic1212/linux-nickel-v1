{
  lib,
  drvs,
  tuigreet | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/apognu/tuigreet/archive/2aeca1b63dec977fc4e2ac6f97432386bedbc546.tar.gz",
      sha256sum = "1bdd45cad37e49ff8bdd33569043959b12c23ae1f2210c336d47bddbc29e8e50"
    },
    crates = lib.functions.filterCrates (import "tuigreet-crates.json"),
    configurePhase = [
      m%"sed -i 's|\/var\/cache\/|\/var\/lib\/|g' ${SRC}/src/info.rs"%,
    ],
  },
  tuigreetConfig | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/etc/dinit.d",
      "install -dm0755 ${DEST}/etc/greetd",
      m%"
        echo '
        command = /usr/bin/greetd -c /etc/greetd/tuigreet-config.toml
        depends-on = loginready
        depends-on = greetd-apply-perms
        logfile = /var/log/tuigreet.log
        smooth-recovery = true
        type = process
        ' > ${DEST}/etc/dinit.d/tuigreet
        "%,
      m%"
    echo '
    [terminal]
    # The VT to run the greeter on. Can be "next", "current" or a number
    # designating the VT.
    vt = 1
    #
    # The default session, also known as the greeter.
    [default_session]
    #
    # agreety is the bundled agetty/login-lookalike. You can replace /bin/sh
    # with whatever you want started, such as sway.
    command = "/usr/bin/tuigreet --cmd fish"
    #
    # The user to run the command as. The privileges this user must have depends
    # on the greeter. A graphical greeter may for example require the user to be
    # in the video group.
    user = "greeter"
    ' > ${DEST}/etc/greetd/tuigreet-config.toml
    "%,
    ]
  }
}
