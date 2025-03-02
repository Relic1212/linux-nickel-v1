{
  lib,

  perl | lib.AutotoolsPackage
    = {
      name = "perl",
      sourceInputs = [
        {
          src = {
            uri = "https://www.cpan.org/src/5.0/perl-5.40.0.tar.gz",
            sha256sum = "c740348f357396327a9795d3e8323bafd0fe8a5c7835fc1cbaba0cc8dfe7161f",
          }
        }
      ],
      configurePhase = [
        "cd ${SRC}",
        m%"./Configure \
    -Dprefix=/usr \
    -Ddlext='none' \
    -Dso='none' \
    -Dcc='clang -static' -Ddynamic_ext='' \
    -Dlddlflags='-static -O2 -L/usr/lib -I/usr/include -fstack-protector-strong' \
    -Dnm_so_opt='' -Dvendorprefix=/usr  -Dusevendorprefix \
    -Dstatic_ext='B Compress/Raw/Bzip2 Compress/Raw/Zlib Cwd Data/Dumper Devel/PPPort Devel/Peek Digest/MD5 Digest/SHA Encode Fcntl File/DosGlob File/Glob Filter/Util/Call Hash/Util Hash/Util/FieldHash I18N/Langinfo IO IPC/SysV List/Util MIME/Base64 Math/BigInt/FastCalc Opcode POSIX PerlIO/encoding PerlIO/mmap PerlIO/via SDBM_File Socket Storable Sys/Hostname Sys/Syslog Time/HiRes Time/Piece Unicode/Collate Unicode/Normalize XS/APItest XS/Typemap attributes mro re threads threads/shared' \
    -Dman1dir=none -Dman3dir=none \
    -Dd_access=true \
    -Dd_eaccess='undef' \
    -des"%,
        "make depend -j$(nproc)",
      ],
      postInstallPhase = [
        "cd ${DEST}",
        m%"
        for f in $(ls); do
          if [ -f "${f}" ]; then
            rm -f "${f}"
          fi
        done
        "%
      ]
    }
}

&

{
  lib,
  drvs,
  perl,
  perlDynamic | lib.AutotoolsPackage = {
    sourceInputs = perl.sourceInputs, 
    separateBuildDir = false,
     configurePhase = [
        m%"./Configure \
        -Dprefix=/usr \
        -Dvendorprefix=/usr  -Dusevendorprefix \
        -Dcc='clang' \
        -Dd_access=true \
        -Dd_eaccess='undef' \
        -des"%,
        "make depend -j$(nproc)",
      ],
      isStatic = false,
      biDrvs=[
                drvs.muslShared,

      ]

  }
}