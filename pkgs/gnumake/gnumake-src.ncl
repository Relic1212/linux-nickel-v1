# let lib = import "../../nickellib/lib.ncl"
# in

# let gnumakeSourceInput | lib.SourceInput
#   = {
#     src = {
#       uri = "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz",
#       sha256sum = "dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3"
#     }
#   }
#   in
# let _g = gnumakeSourceInput
# in

# { gnumakeSourceInput = _g }

{
      uri = "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz",
      sha256sum = "dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3"
    }