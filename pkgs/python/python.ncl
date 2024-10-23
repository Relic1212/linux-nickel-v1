let lib = import "../../nickellib/lib.ncl"
in
let pythonBaseBase | lib.AutotoolsPackage
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
let pythonBase = pythonBaseBase
in
{
  pythonStage1 | lib.AutotoolsPackage
    =
      pythonBase
      & {
        # enableCcache|force=false,
        stage = 1,
        buildInputs = [
          (import "../busybox/busybox-stage-0.ncl"),
          (import "../llvm/llvm-stage-0.ncl"),
          (import "../musl/musl-stage-0.ncl"),
          (import "../gnumake/gnumake-stage-1.ncl"),
          (import "../ccache/ccache-bin.ncl"),
        ],
        configurePhase = (
          (pythonBase.configurePhase)
          @ [
            m%"
        printf "
        *static*
        _random _randommodule.c
        _struct _struct.c
        _typing _typingmodule.c
        math mathmodule.c
        _json _json.c
        _socket socketmodule.c
        _pickle _pickle.c
        _elementtree _elementtree.c
        *disabled*
        _testinternalcapi
        nis
        _ctypes_test
        _testcapi
        _testimportmultiple
        _testmultiphase
        _testsinglephase
        _gdbm
        _dbm
        readline
        _tkinter
        _curses
        _curses_panel
        _sqlite3
        _testclinic
        _bz2
        _asyncio
        _bisect
        _contextvars
        _csv
        _datetime
        _decimal
        _heapq
        _lsprof
        _multiprocessing
        _opcode
        _queue
        _statistics
        _zoneinfo
        array
        audioop
        binascii
        cmath
        mmap
        select
        pyexpat
        _blake2
        _md5
        _sha1
        _sha2
        _sha3
        _codecs_cn
        _codecs_hk
        _codecs_iso2022
        _codecs_jp
        _codecs_kr
        _codecs_tw
        _multibytecodec
        unicodedata
        _posixsubprocess
        _posixshmem
        fcntl
        grp
        ossaudiodev
        resource
        spwd
        syslog
        termios
        _crypt
        nis
        _bz2
        _ctypes
        _dbm
        _lzma
        _uuid
        zlib
        _ssl
        _hashlib
        _curses
        _curses_panel
        xx
        xxlimited
        xxlimited_35
        xxsubtype
        _xxsubinterpreters
        _xxinterpchannels
        _xxtestfuzz
        _testbuffer
        _ctypes
        " > ./Modules/Setup.local
        "%
          ]
        ),
      }
}
