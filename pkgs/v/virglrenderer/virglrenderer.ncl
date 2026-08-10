{
  lib,
  drvs,
  virglrenderer | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-1.3.0/virglrenderer-virglrenderer-1.3.0.tar.gz",
      sha256sum = "56170f8caa1bb642a2624b649e3bcca095ec2834814e5c308efc8a85a709e4ce"
    },
    extraMesonArgs = [
      "-Dplatforms=egl",
      "-Dvideo=true",
      # "-Ddrm-amdgpu=true",
      # "-Ddrm-renderers='amdgpu-experimental,i915-experimental'",
      "-Ddrm-renderers='amdgpu-experimental'",
      # "-Drender-server-worker='process,thread'",
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--error-limit=0",
      ],
    },

    preConfigurePhase = [
      m%"sed -i "s@subdir('vtest')@@" ${SRC}/meson.build"%,
    ],

    postInstallPhase =
      let syms = [
        "_mesa_hash_table_clear",
        "_mesa_hash_table_clone",
        "_mesa_hash_table_create",
        "_mesa_hash_table_create_u32_keys",
        "_mesa_hash_table_destroy",
        "_mesa_hash_table_init",
        "_mesa_hash_table_insert",
        "_mesa_hash_table_insert_pre_hashed",
        "_mesa_hash_table_next_entry",
        "_mesa_hash_table_remove",
        "_mesa_hash_table_remove_key",
        "_mesa_hash_table_search",
        "_mesa_hash_table_search_pre_hashed",
        "_mesa_hash_table_set_deleted_key",
        "tgsi_dump",
        "tgsi_dump_instruction",
        "tgsi_dump_instruction_str",
        "tgsi_dump_str",
        "tgsi_dump_to_file",
        "tgsi_swizzle_names",
        "util_hash_table_foreach",
        "util_hash_table_get",
        "_mesa_hash_data",
        "_mesa_hash_data_with_seed",
        "_mesa_hash_int",
        "_mesa_hash_pointer",
        "_mesa_hash_string",
        "_mesa_hash_table_next_entry_unsafe",
        "_mesa_hash_table_random_entry",
        "_mesa_hash_table_reserve",
        "_mesa_hash_table_u64_clear",
        "_mesa_hash_table_u64_create",
        "_mesa_hash_table_u64_destroy",
        "_mesa_hash_table_u64_insert",
        "_mesa_hash_u32",
        "_mesa_hash_uint",
        "_mesa_key_int_equal",
        "_mesa_key_pointer_equal",
        "_mesa_key_string_equal",
        "_mesa_key_u32_equal",
        "_mesa_key_uint_equal",
        "_mesa_pointer_hash_table_create",
        "_mesa_hash_table_u64_remove",
        "_mesa_hash_table_u64_search",
      ]
      in
      std.array.map (fun s => "llvm-objcopy --redefine-sym %{s}=__virglrenderer_private_%{s} ${DEST}/usr/lib/libvirglrenderer.a") syms,

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pyyaml,
    ],
    pDrvs = [
      drvs.libepoxy,
      drvs.libva,
    ],
  }
}
