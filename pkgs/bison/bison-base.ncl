let lib = import "../../nickellib/lib.ncl"
in
let 
bisonBase|lib.AutotoolsPackage={
    name|default="bison",
    sourceInputs=[
        {
            src={ uri="https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz", sha256sum="9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2" }
        }
    ],

}
in 
bisonBase