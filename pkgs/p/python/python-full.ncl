(import "python-base.ncl")
& {
  drvs,
  lib,
  _pythonBase,
  pythonFull =
    _pythonBase
    & {
      # enableCcache|force=false,
      name | priority 1 = "python-full",
      isStatic,

      configurePhase = (
        ["cd ${SRC}"]
        @ (_pythonBase.configurePhase)
        @ (
          if isStatic then
            [
              m%"
        printf "
        *static*
        _asyncio _asynciomodule.c
        _bisect _bisectmodule.c
        _contextvars _contextvarsmodule.c
        _csv _csv.c
        _datetime _datetimemodule.c
        _decimal _decimal/_decimal.c
        _heapq _heapqmodule.c
        _json _json.c
        _lsprof _lsprof.c rotatingtree.c
        _multiprocessing -I$(srcdir)/Modules/_multiprocessing _multiprocessing/multiprocessing.c _multiprocessing/semaphore.c
        _opcode _opcode.c
        _pickle _pickle.c
        _queue _queuemodule.c
        _random _randommodule.c
        _socket socketmodule.c
        _statistics _statisticsmodule.c
        _struct _struct.c
        _typing _typingmodule.c
        _zoneinfo _zoneinfo.c
        array arraymodule.c
        audioop audioop.c
        binascii binascii.c
        cmath cmathmodule.c
        math mathmodule.c
        mmap mmapmodule.c
        select selectmodule.c
        _elementtree _elementtree.c
        pyexpat pyexpat.c
        _blake2 _blake2/blake2module.c _blake2/blake2b_impl.c _blake2/blake2s_impl.c
        _md5 md5module.c -I./Modules/_hacl/include _hacl/Hacl_Hash_MD5.c -D_BSD_SOURCE -D_DEFAULT_SOURCE
        _sha1 sha1module.c -I./Modules/_hacl/include _hacl/Hacl_Hash_SHA1.c -D_BSD_SOURCE -D_DEFAULT_SOURCE
        _sha2 sha2module.c -I./Modules/_hacl/include Modules/_hacl/libHacl_Hash_SHA2.a
        _sha3 sha3module.c -I./Modules/_hacl/include _hacl/Hacl_Hash_SHA3.c -D_BSD_SOURCE -D_DEFAULT_SOURCE
        _codecs_cn cjkcodecs/_codecs_cn.c
        _codecs_hk cjkcodecs/_codecs_hk.c
        _codecs_iso2022 cjkcodecs/_codecs_iso2022.c
        _codecs_jp cjkcodecs/_codecs_jp.c
        _codecs_kr cjkcodecs/_codecs_kr.c
        _codecs_tw cjkcodecs/_codecs_tw.c
        _multibytecodec cjkcodecs/multibytecodec.c
        unicodedata unicodedata.c
        _posixsubprocess _posixsubprocess.c
        _posixshmem -I$(srcdir)/Modules/_multiprocessing _multiprocessing/posixshmem.c -lrt
        fcntl fcntlmodule.c
        grp grpmodule.c
        ossaudiodev ossaudiodev.c
        resource resource.c
        spwd spwdmodule.c
        syslog syslogmodule.c
        termios termios.c
        _crypt _cryptmodule.c -lcrypt
        #nis nismodule.c -I/usr/include/tirpc -lnsl -ltirpc
        #_bz2 _bz2module.c -lbz2
        _ctypes _ctypes/_ctypes.c _ctypes/callbacks.c _ctypes/callproc.c _ctypes/stgdict.c _ctypes/cfield.c -ldl -lffi -DHAVE_FFI_PREP_CIF_VAR -DHAVE_FFI_PREP_CLOSURE_LOC -DHAVE_FFI_CLOSURE_ALLOC
        #_dbm _dbmmodule.c -lgdbm_compat -DUSE_GDBM_COMPAT
        #_lzma _lzmamodule.c -llzma
        #_uuid _uuidmodule.c -luuid -I/usr/include/uuid
        zlib  zlibmodule.c -lz
        # To statically link OpenSSL:
        _ssl _ssl.c $(OPENSSL_INCLUDES) $(OPENSSL_LDFLAGS) \
            -l:libssl.a -Wl,--exclude-libs,libssl.a \
            -l:libcrypto.a -Wl,--exclude-libs,libcrypto.a
        _hashlib _hashopenssl.c $(OPENSSL_INCLUDES) $(OPENSSL_LDFLAGS) \
            -l:libcrypto.a -Wl,--exclude-libs,libcrypto.a
        #_curses -lncurses -lncursesw  _cursesmodule.c
        #_curses_panel -lpanel -lncurses _curses_panel.c
        xx xxmodule.c
        xxlimited xxlimited.c
        xxlimited_35 xxlimited_35.c
        xxsubtype xxsubtype.c
        _xxsubinterpreters _xxsubinterpretersmodule.c
        _xxinterpchannels _xxinterpchannelsmodule.c
        _xxtestfuzz _xxtestfuzz/_xxtestfuzz.c _xxtestfuzz/fuzzer.c
        _testbuffer _testbuffer.c
        _ctypes
        *disabled*
        _testinternalcapi _testinternalcapi.c
        nis nismodule.c
        _ctypes_test _ctypes/_ctypes_test.c
        _testcapi _testcapimodule.c
        _testimportmultiple _testimportmultiple.c
        _testmultiphase _testmultiphase.c
        _testsinglephase _testsinglephase.c
        _gdbm _dbm
        readline
        _tkinter
        _curses
        _curses_panel
        _sqlite3
        _testclinic
        _bz2 _bz2module.c

        " > ./Modules/Setup.local"%
            ]
          else
            []
        )
      ),
      installPhase =
        lib.AutotoolsPackage.installPhase
        @ [
          "cd $DEST/usr/bin",
          "ln -s python3 python",
        ],
      biDrvs = [
        drvs.linuxHeaders,
        drvs.zlibNg,
        drvs.pkgconf,
        drvs.libffi,
        drvs.openssl
      ]
    },

  pythonInteractive =
    _pythonBase
    & {
      isStatic,

      configurePhase = (
        ["cd ${SRC}"]
        @ (_pythonBase.configurePhase)
        @ (
          if isStatic then
            [
              m%"
        printf "
        *static*
        _asyncio _asynciomodule.c
        _bisect _bisectmodule.c
        _contextvars _contextvarsmodule.c
        _csv _csv.c
        _datetime _datetimemodule.c
        _decimal _decimal/_decimal.c
        _heapq _heapqmodule.c
        _json _json.c
        _lsprof _lsprof.c rotatingtree.c
        _multiprocessing -I$(srcdir)/Modules/_multiprocessing _multiprocessing/multiprocessing.c _multiprocessing/semaphore.c
        _opcode _opcode.c
        _pickle _pickle.c
        _queue _queuemodule.c
        _random _randommodule.c
        _socket socketmodule.c
        _statistics _statisticsmodule.c
        _struct _struct.c
        _typing _typingmodule.c
        _zoneinfo _zoneinfo.c
        array arraymodule.c
        audioop audioop.c
        binascii binascii.c
        cmath cmathmodule.c
        math mathmodule.c
        mmap mmapmodule.c
        select selectmodule.c
        _elementtree _elementtree.c
        pyexpat pyexpat.c
        _blake2 _blake2/blake2module.c _blake2/blake2b_impl.c _blake2/blake2s_impl.c
        _md5 md5module.c -I./Modules/_hacl/include _hacl/Hacl_Hash_MD5.c -D_BSD_SOURCE -D_DEFAULT_SOURCE
        _sha1 sha1module.c -I./Modules/_hacl/include _hacl/Hacl_Hash_SHA1.c -D_BSD_SOURCE -D_DEFAULT_SOURCE
        _sha2 sha2module.c -I./Modules/_hacl/include Modules/_hacl/libHacl_Hash_SHA2.a
        _sha3 sha3module.c -I./Modules/_hacl/include _hacl/Hacl_Hash_SHA3.c -D_BSD_SOURCE -D_DEFAULT_SOURCE
        _codecs_cn cjkcodecs/_codecs_cn.c
        _codecs_hk cjkcodecs/_codecs_hk.c
        _codecs_iso2022 cjkcodecs/_codecs_iso2022.c
        _codecs_jp cjkcodecs/_codecs_jp.c
        _codecs_kr cjkcodecs/_codecs_kr.c
        _codecs_tw cjkcodecs/_codecs_tw.c
        _multibytecodec cjkcodecs/multibytecodec.c
        unicodedata unicodedata.c
        _posixsubprocess _posixsubprocess.c
        _posixshmem -I$(srcdir)/Modules/_multiprocessing _multiprocessing/posixshmem.c -lrt
        fcntl fcntlmodule.c
        grp grpmodule.c
        ossaudiodev ossaudiodev.c
        resource resource.c
        spwd spwdmodule.c
        syslog syslogmodule.c
        termios termios.c
        _crypt _cryptmodule.c -lcrypt
        #nis nismodule.c -I/usr/include/tirpc -lnsl -ltirpc
        #_bz2 _bz2module.c -lbz2
        _ctypes _ctypes/_ctypes.c _ctypes/callbacks.c _ctypes/callproc.c _ctypes/stgdict.c _ctypes/cfield.c -ldl -lffi -DHAVE_FFI_PREP_CIF_VAR -DHAVE_FFI_PREP_CLOSURE_LOC -DHAVE_FFI_CLOSURE_ALLOC
        #_dbm _dbmmodule.c -lgdbm_compat -DUSE_GDBM_COMPAT
        #_lzma _lzmamodule.c -llzma
        #_uuid _uuidmodule.c -luuid -I/usr/include/uuid
        zlib  zlibmodule.c -lz
        # To statically link OpenSSL:
        _ssl _ssl.c $(OPENSSL_INCLUDES) $(OPENSSL_LDFLAGS) \
            -l:libssl.a -Wl,--exclude-libs,libssl.a \
            -l:libcrypto.a -Wl,--exclude-libs,libcrypto.a
        _hashlib _hashopenssl.c $(OPENSSL_INCLUDES) $(OPENSSL_LDFLAGS) \
            -l:libcrypto.a -Wl,--exclude-libs,libcrypto.a
        _curses -lncurses -lncursesw  _cursesmodule.c
        _curses_panel -lpanel -lncurses _curses_panel.c
        readline readline.c -lreadline -lncursesw
        xx xxmodule.c
        xxlimited xxlimited.c
        xxlimited_35 xxlimited_35.c
        xxsubtype xxsubtype.c
        _xxsubinterpreters _xxsubinterpretersmodule.c
        _xxinterpchannels _xxinterpchannelsmodule.c
        _xxtestfuzz _xxtestfuzz/_xxtestfuzz.c _xxtestfuzz/fuzzer.c
        _testbuffer _testbuffer.c
        _ctypes
        _bz2 _bz2module.c
        *disabled*
        _testinternalcapi _testinternalcapi.c
        nis nismodule.c
        _ctypes_test _ctypes/_ctypes_test.c
        _testcapi _testcapimodule.c
        _testimportmultiple _testimportmultiple.c
        _testmultiphase _testmultiphase.c
        _testsinglephase _testsinglephase.c
        _gdbm _dbm
        _tkinter
        _sqlite3
        _testclinic
        " > ./Modules/Setup.local"%
            ]
          else
            []
        )
      ),
      installPhase =
        lib.AutotoolsPackage.installPhase
        @ [
          "install -dm0755 ${DEST}/usr/lib/python3.12/libpython",
          "for f in $(find ${SRC}/Modules -name '*.a'); do  install -m0755 ${f} ${DEST}/usr/lib/python3.12/libpython;done",
          "cd $DEST/usr/bin",
          "ln -s python3 python",
        ],
      biDrvs = [
        drvs.linuxHeaders,
        drvs.zlibNg,
        drvs.pkgconf,
        drvs.libffi,
        drvs.openssl,
        drvs.ncurses,
        drvs.readline,
        drvs.bzip2,
      ]
    },

  pythonDl | lib.AutotoolsPackage =
    pythonInteractive
    & {
      neverInclude = [
        drvs.musl
      ],
      biDrvs | priority 1 = pythonInteractive.biDrvs @ [drvs.muslBothRenamedDlRelease],
      preConfigurePhase | priority 1 = [
        lib.functions.writeFile "${SRC}/dlopen.c" (import "python_dlopen.c" as 'Text),
        "clang -O2 -Werror -c ${SRC}/dlopen.c -o ${BUILDDIR}/dlopen.o",
        "ar rcs ${BUILDDIR}/libdlopen.a ${BUILDDIR}/dlopen.o",
        "ranlib ${BUILDDIR}/libdlopen.a",
        # "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/dlopen.o\"",
        "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/libdlopen.a\"",
        # "export LDFLAGS=\"${LDFLAGS} -Wl,--allow-multiple-definition=dlopen\"",
      ],
    },

  pythonDynamic =
    pythonFull
    & {
      name | priority 20 = "python-dynamic",
      isStatic | priority 2 = false,
      biDrvs | priority 1 = [
        drvs.linuxHeaders,
        drvs.zlibNgPic,
        drvs.pkgconf,
        drvs.libffi,
        drvs.opensslPic,
        drvs.muslShared,
      ]
    },
  pythonDynamicCurses =
    pythonDynamic
    & {
      biDrvs | priority 3 =
        pythonDynamic.biDrvs
        @ [
          drvs.ncursesPic,
          # drvs.readlinePic,
        ]
    },

  pythonDynamicPic =
    pythonDynamic
    & {
      preConfigurePhase = [
        "export CFLAGS=\"${CFLAGS} -fPIC\"",
        "export CXXFLAGS=\"${CXXFLAGS} -fPIC\"",
        "export LDFLAGS=\"${LDFLAGS} -fPIC\"",
      ]
    },
  pythonDynamicPicBz2 =
    pythonDynamicPic
    & {
      biDrvs | priority 2 =
        pythonDynamicPic.biDrvs
        @ [
          drvs.bzip2,
        ]
    }
}
