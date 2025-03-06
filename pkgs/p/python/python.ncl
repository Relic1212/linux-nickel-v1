(import "python-base.ncl")
& {
  lib,
  pkgs,
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
      buildInputs =
        lib.biMap [
          pkgs.busyboxBootstrapStage0,
          pkgs.bootstrapStage0,
          pkgs.bootstrapSymlinks,
          pkgs.ccacheBin,
          pkgs.gnumakeStage1,
        ],
    },

  # 2

  pythonStage2 =
    _pythonBaseMinimal
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.llvmStage1,
          pkgs.gnumakeStage2,
          pkgs.ccacheBin,
          pkgs.muslStage1
        ],
    },

  pythonStage3 =
    _pythonBaseMinimal
    & {
      stage = 3,
      utilsProviders = [],
      baseBuildinputPackages = [],

      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.gnumakeStage4,
          pkgs.ccacheBin,
          pkgs.muslStage3
        ],
    },

  # final

  python =
    _pythonBaseMinimal
    & {
      stage = -1,
      utilsProviders = [],
      baseBuildinputPackages = [],

      buildInputs =
        lib.biMap [
          pkgs.busyboxStage3,
          pkgs.llvmStage3,
          pkgs.gnumake,
          pkgs.ccacheBin,
          pkgs.musl
        ],
    },
}
