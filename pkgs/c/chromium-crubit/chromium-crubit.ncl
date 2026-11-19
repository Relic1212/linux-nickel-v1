{
  lib,
  drvs,
  chromiumCrubit | lib.CargoPackage = {
    singleSource = {
      # uri = "https://github.com/google/crubit/archive/03788714e282614d1bf145fdf76b2f06f48a3fe5.tar.gz",
      # sha256sum = "6f46aa4841b2fce5351be867953d034ce2a1556e8fe048e9876d21c305f13f61",
      ###
      # uri = "https://github.com/google/crubit/archive/602069385137e46c3c88b6bf8712eb31ddba284b.tar.gz",
      # sha256sum = "c647456c30b5d840de7b88bb6e6f32270c04ba8a0283e320156c2c463cde93b8",
      ###

      # uri = "https://github.com/google/crubit/archive/fbf3f8949473d0c327a8076e1df534834ba0f8a8.tar.gz",
      # sha256sum = "c3739b3eb501630be476f9d1d03318046ea756d5896246d8678b5cfa1e592ef7",  
      ###
      # uri = "https://github.com/google/crubit/archive/322b266fdf8ddac19af3968c278569d7a2f8bbd0.tar.gz",
      # sha256sum = "1274eba7c68429c2de56f265bdd6e2872d7ec765a24300187a78988e9237274e",

      ##

      # uri = "https://github.com/google/crubit/archive/69b85cba43f85a6439dc0be86a6fe424bb07a100.tar.gz",
      # sha256sum = "af8910353d7694c2a97231b7ce346f8cf7a27912dd4fe52bf631bb82a99f4bcd",
      ###
      # uri = "https://github.com/google/crubit/archive/6340ea37543c492f238678d15d3eef263aa0c328.tar.gz",
      # sha256sum = "5460f3c9f531d633c396f32330c0ffff22f322aaa68576de4343290d6fd14e6d",

      # uri = "https://github.com/google/crubit/archive/6837ecd4bdbe44c2110349df51510dd149d44466.tar.gz",
      # sha256sum = "10adae6d2342d3b77384d6004a597e9b27e824380ef21c53d5ea55fafd4bf698",

      uri = "https://github.com/google/crubit/archive/20dc640430bd60ff2f7f8dbf69c311c5f807adde.tar.gz", # https://github.com/chromium/chromium/blob/157.0.8103.81/tools/rust/update_rust.py
      sha256sum = "bb8ae2268825a73c0a79e65e9fda3329f38371ee36a7c1d63d92c194cc505ecf",

      # uri = "https://github.com/google/crubit/archive/976349ab38ef144ac8f9f6ab63a8ef62185e71b8.tar.gz",
      # sha256sum = "02e009be1b5baae3d13dd014d8bf662484466258542403fd95bd2921d12bbd13",
    },

    crates = lib.functions.filterCrates (import "crubit-crates.json"),

    # eofPatches = [
    #   {
    #     patch = import "chromium-crubit-2.patch" as 'Text,
    #   },
    # ],

    extraEnv = {
      RUSTC_BOOTSTRAP = "1",

      ABSL_INCLUDE_PATH = "/usr/include",
      ABSL_LIB_STATIC_PATH = "/usr/lib",
      CLANG_INCLUDE_PATH = "/usr/include",
      CLANG_LIB_STATIC_PATH = "/usr/lib",
      # PROTOBUF_INCLUDE_PATH = "/usr/include/google/protobuf",
      PROTOBUF_INCLUDE_PATH = "/usr/include",
      #   PROTOBUF_INCLUDE_PATH = "generated_headers",
      PROTOBUF_LIB_STATIC_PATH = "/usr/lib",

      #   CRUBIT_LLVM_DEV_DATE = "19700101",
    },
    buildEnv = {
      EXTRA_CXXFLAGS = [
        # "-DCRUBIT_LLVM_DEV_DATE=19700101",
        "-DCRUBIT_LLVM_DEV_DATE=20251001",
        # "-DCRUBIT_LLVM_DEV_DATE=20260818",
        # "-DCRUBIT_LLVM_DEV_DATE=20260901",
        "-fexperimental-library",
      ],
    },
    extraEnv = {
      # rustc_driver is needed and is a dylib: https://github.com/rust-lang/rust/issues/55741
      STATIC_RUSTFLAGS = [
        "-C prefer-dynamic",
        "-C target-feature=-crt-static",
      ],
    },
    target | priority 1 = "",
    baseCargoFlags = [
      "--offline",
      # "--target %{target}"
    ],
    extraCargoFlags = [
      "--bin rs_bindings_from_cc",
      "--bin cc_bindings_from_rs",
      # "--manifest-path cargo/cc_bindings_from_rs/cc_bindings_from_rs/Cargo.toml",
    ],
    configurePhase = [
      m%"sed -i 's@ictx.getDefaultedFunctionKind@ictx.sema_.getDefaultedFunctionKind@g' ${SRC}/rs_bindings_from_cc/ast_util.cc"%,
      "python cargo/build/generate_proto_headers.py --protoc=/usr/bin/protoc --out_dir=generated_headers",
      "export PROTOBUF_INCLUDE_PATH=\"${PROTOBUF_INCLUDE_PATH},${SRC}/generated_headers\"",
      # "cargo build --release --offline	--target x86_64-unknown-linux-musl --bin cc_bindings_from_rs"
    ],
    postInstallPhase = [
      # "install",
    ],

    llvmProvider = drvs.llvmFull,
    # rustProvider = drvs.rustProfiler,

    biDrvs = [
      drvs.protobuf361,
      drvs.pythonFull,
      drvs.libstdcppCompat,
    ],
    pDrvs = [
      drvs.abseilCpp,
      drvs.zlibNg,
    ],
  },
  chromiumCrubitSource | lib.Package = {
    singleSource = chromiumCrubit.singleSource,
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/third_party/crubit",
      "cp -r ${SRC}/* ${DEST}/usr/lib/third_party/crubit",
    ]
  }
}
