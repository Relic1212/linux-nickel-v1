{
  lib,
  drvs,
  pythonIgnis | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/ignis-sh/ignis/archive/refs/tags/v0.6.0.tar.gz",
      sha256sum = "b634a4c47450fb1f1897c8e1fcc2e914193bde03bf9bb03ac9335bb58009760c",
    },
    preConfigurePhase = [
      "export HOME=/tmp/home",
      "mkdir \"${HOME}\"",
      "git config --global user.email \"you@example.com\"",
      "git config --global user.name \"Your Name\"",
      "git init",
      "git add .",
      "git commit -m 'initial commit'",
    ],
    biDrvs = [
      drvs.git,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonHatchVcs,
      drvs.pythonSetuptoolsScm,
      drvs.pythonTroveClassifiers,
    ],
  }
}
&{

lib,
drvs,


  pythonFull,
  pythonIgnisInterpreter | lib.AutotoolsPackage =
    pythonFull
    & {
      options = {
        c_src | default = (import "../../d/dbus-python/dbus_python_init.c" as 'Text),
      },
      separateBuildDir=false,
      buildEnv = {
        EXTRA_LDFLAGS = [
          "$(pkg-config --libs --static dbus-1 python3 glib-2.0 gobject-2.0 girepository-2.0 libudev cairo pango gdk-pixbuf-2.0 atk cairo-gobject gtk4 gtk4-layer-shell-0 libpulse libpulse-mainloop-glib libnm)",
          # "-ludev -luuid -lgnutls -lhogweed -lgmp -lnettle -ltasn1 -lp11-kit -lgio-2.0 -lgobject-2.0 -lffi -lgmodule-2.0 -lglib-2.0 -lm -pthread -lpcre2-8 -lz",
          "-l_dbus_bindings",
          "-l_dbus_glib_bindings",
          "-l_gi",
          "-l_cairo",
          "-lpython_ps_util",
          "/usr/lib/ignis-gvc/libgvc.a",
        ],

        EXTRA_CPPFLAGS = [
          "-Dg_reparseDeferralEnabledDefault=python__g_reparseDeferralEnabledDefault",
          "-D_INTERNAL_trim_to_complete_utf8_characters=python___INTERNAL_trim_to_complete_utf8_characters",
        ],
      },
      extraConfigureFlags|priority 1 =[]@[
# "py_cv_module__uuid='no'",
"ac_cv_func_fdwalk='no'"
      ]@pythonFull.extraConfigureFlags,
      preConfigurePhase | priority 1 = [
        lib.functions.writeFile "${SRC}/init.c" options.c_src,
        lib.functions.writeFile "${SRC}/glib.json" (let d = import "../../d/dbus-python/_glib.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/gobject.json" (let d = import "../../d/dbus-python/_gobject.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/gio.json" (let d = import "../../d/dbus-python/_gio.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/gtk4.json" (let d = import "_gtk4.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/atk.json" (let d = import "../../d/dbus-python/_atk.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/cairo_gobject.json" (let d = import "../../d/dbus-python/_cairo_gobject.ncl" in std.serialize 'Json d),
         lib.functions.writeFile "${SRC}/gtk4_layer_shell.json" (let d = import "_gtk4_layer_shell.ncl" in std.serialize 'Json d),
         lib.functions.writeFile "${SRC}/gvc.json" (let d = import "_gvc.ncl" in std.serialize 'Json d),
         lib.functions.writeFile "${SRC}/nm.json" (let d = import "_nm.ncl" in std.serialize 'Json d),
        let s = m%""g_option_error_quark","g_quark_to_string","g_error_get_type","g_io_condition_get_type","g_main_loop_get_type","g_main_context_get_type","g_source_get_type","g_io_channel_get_type","g_pollfd_get_type","g_main_loop_new","g_main_loop_get_context","g_main_loop_run","g_main_loop_quit","g_type_from_name","g_value_get_type","g_object_get_type","g_binding_get_type","g_initially_unowned_get_type","g_binding_flags_get_type","g_main_context_default","g_io_channel_unix_new","g_value_init" "% in
        "dl-func %{std.string.join " "[
          # m%"'{"names":["libglib-2.0.so.0"],"symbols":[%{s}]}'"%,
          # m%"'{"names":["libgobject-2.0.so.0"],"symbols":[%{s}]}'"%,

          "'%{(let d = import "../../d/dbus-python/_pango.ncl" in let d1 = std.serialize 'Json d in let s1 =std.string.replace "\n" "" d1 in std.string.replace " " "" s1)}'",
          "'%{(let d = import "../../d/dbus-python/_gdk_pixbuf.ncl" in let d1 = std.serialize 'Json d in let s1 =std.string.replace "\n" "" d1 in std.string.replace " " "" s1)}'",
        
          "'%{(let d = import "../../d/dbus-python/_udev.ncl" in let d1 = std.serialize 'Json d in let s1 =std.string.replace "\n" "" d1 in std.string.replace " " "" s1)}'",


          "--file=${SRC}/glib.json",
          "--file=${SRC}/gobject.json",
          "--file=${SRC}/gio.json",
          "--file=${SRC}/gtk4.json",
          "--file=${SRC}/atk.json",
          "--file=${SRC}/cairo_gobject.json",
            "--file=${SRC}/gtk4_layer_shell.json",
            "--file=${SRC}/gvc.json",
             "--file=${SRC}/nm.json",
          m%"'{"names":[],"symbols":["python_dbus_module_init"]}'"%,
        


        ]} > ${SRC}/dlopen.c",
        "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${BUILDDIR}/dlopen.o",
        "${CC} ${CFLAGS} $(pkg-config --cflags python3) -Werror -c ${SRC}/init.c -o ${BUILDDIR}/init.o",
        "ar rcs ${BUILDDIR}/libdlopen.a ${BUILDDIR}/dlopen.o ${BUILDDIR}/init.o",
        "ranlib ${BUILDDIR}/libdlopen.a",
        # "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/dlopen.o\"",
        "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/libdlopen.a\"",
        # "export LDFLAGS=\"${LDFLAGS} -Wl,--allow-multiple-definition=dlopen\"",
      ],
configureFlags,
configurePhase |priority 1 =[
"./configure %{std.string.join " " configureFlags}",
],


preBuildPhase=[

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
        _ctypes _ctypes/_ctypes.c _ctypes/callbacks.c _ctypes/callproc.c _ctypes/stgdict.c _ctypes/cfield.c -ldl -lffi -DHAVE_FFI_PREP_CIF_VAR -DHAVE_FFI_PREP_CLOSURE_LOC -DHAVE_FFI_CLOSURE_ALLOC
        #_dbm _dbmmodule.c -lgdbm_compat -DUSE_GDBM_COMPAT
        #_lzma _lzmamodule.c -llzma
        _uuid _uuidmodule.c -luuid -I/usr/include/uuid
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
],

      postInstallPhase = [
        # m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/_sysconfigdata__linux_x86_64-linux-gnu.py"%,
        # m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/config-3.12-x86_64-linux-gnu/Makefile"%,
        "cd ${DEST}/usr",
        "rm -rf lib include share",
        "cd bin",
        "ls | grep -v python3.12|xargs rm",
        "rm python3.12-config",
        "mv python3.12 python-ignis",
      ],

      llvmProvider = drvs.llvmFull,
      neverInclude = [
        drvs.musl,
        drvs.cairo,
        drvs.gdkPixbuf,
        drvs.eudev,
      ],
      biDrvs | priority 1 =
        pythonFull.biDrvs
        @ [
          drvs.muslBothRenamedDl,
          # drvs.musl,
          drvs.pythonFull,
          drvs.pythonDlFunc,
        ],

      pDrvs = [
        drvs.dbusPython,
        drvs.pythonPygobjectStatic,
        drvs.pythonPycairoStatic,
        drvs.pythonPsutil,
        drvs.eudevNm,
        drvs.pango,
        drvs.gdkPixbufFull,
        drvs.cairoGobject,
        drvs.gtk4,
        drvs.atSpi2Core,
         drvs.gtk4LayerShell,
         drvs.ignisGvc,
         drvs.networkmanager,
        #  drvs.utilLinux,
         drvs.bzip2,
        #  drvs.ncurses,
         drvs.readline,
      ],
      allowDubplicateBuldInputs = true,
    },
}


