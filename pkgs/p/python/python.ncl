(import "python-base.ncl")
& {
  lib,
  drvs,
  _pythonBase,
  #base with minimal modules
  _pythonBaseMinimal | lib.AutotoolsPackage =
    _pythonBase
    & {
      buildEnv = {
        _isLlvm = false,
        STAGE_CFLAGS = [
          "-I/include"
        ],
        STAGE_CPPFLAGS = [
          "-I/include",
        ],
        CXX = ["x86_64-linux-musl-g++", "--verbose", "--sysroot=/"],
        CXXFLAGS = [
          "-I/include/c++/9.4.0",
          # "-I/include",
          #"-idirafter/include"
        ],
      },
      # enableCcache|force=false,

      configurePhase = (
        (_pythonBase.configurePhase)
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
        _posixsubprocess _posixsubprocess.c
        select selectmodule.c
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
    },
  # stage 1
  pythonStage1 =
    _pythonBaseMinimal
    & {
      stage = 1,
      buildInputs = [
        drvs.busyboxBootstrapStage0,
        drvs.bootstrapStage0,
        drvs.bootstrapSymlinks,
        drvs.ccacheBin,
        drvs.gnumakeStage1,
      ],
    },

  # 2

  pythonStage2 =
    _pythonBaseMinimal
    & {
      stage = 2,
      buildInputs = [
        drvs.busyboxStage1,
        drvs.llvmStage1,
        drvs.gnumakeStage2,
        drvs.ccacheBin,
        drvs.muslStage1
      ],
    },

  pythonStage3 =
    _pythonBaseMinimal
    & {
      stage = 3,
      utilsProviders = [],
      baseBuildinputPackages = [],

      buildInputs = [
        drvs.busyboxStage2,
        drvs.llvmStage2,
        drvs.gnumakeStage4,
        drvs.ccacheBin,
        drvs.muslStage3
      ],
    },

  # final

  python =
    _pythonBaseMinimal
    & {
      stage = -1,
      utilsProviders = [],
      baseBuildinputPackages = [],

      buildInputs = [
        drvs.busyboxStage3,
        drvs.llvmStage3,
        drvs.gnumake,
        drvs.ccacheBin,
        drvs.musl
      ],
    },
}
