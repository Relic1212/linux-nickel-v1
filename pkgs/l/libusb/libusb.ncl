{
  lib,
  drvs,
  libusb | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/libusb/libusb/releases/download/v1.0.29/libusb-1.0.29.tar.bz2",
      sha256sum = "5977fc950f8d1395ccea9bd48c06b3f808fd3c2c961b44b0c2e6e29fc3a70a85"
    },
    # extraConfigureFlags=[
    #   "--disable-udev"
    # ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.eudev,
    ],
  }
}
