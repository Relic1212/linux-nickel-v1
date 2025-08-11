{
  lib,
  drvs,
  basu | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~emersion/basu/refs/download/v0.2.1/basu-0.2.1.tar.gz",
      sha256sum = "d9b373a9fcb5d5eb5f6c1c56355f76edb7f2f52bc744570e80604e83455a19bd",
    },
    biDrvs = [
      drvs.gperf,
      drvs.muslGetent,
    ]
  },
  basuUdevCompatible =
    basu
    & {

      postInstallPhase =
        let symbols = [
          "log_oom_internal",
          "page_size",
          "get_process_comm",
          "now",
          "endswith",
          "timespec_load",
          "cescape_char",
          "unichar_is_valid",
          "utf8_encoded_to_unichar",
          "utf8_encoded_valid_unichar",
          "octchar",
          "close_nointr",
          "timespec_store",
          "safe_close",
          "close_many",
          "parse_uid",
          "safe_atoi",
          "safe_atollu",
          "safe_atolli",
          "strnappend",
          "path_startswith",
          "path_compare",
          "strappend",
          "hexchar",
          "strv_clear",
          "strv_free",
          "strv_copy",
          "strv_length",
          "strv_new_ap",
          "strv_push",
          "strv_consume",
          "strv_extend",
          "unhexchar",
          "loop_read",
          "fd_wait_for_event",
          "loop_read_exact",
          "log_level_to_string_alloc",
          "log_level_from_string",
          "fd_inc_sndbuf",
          "greedy_realloc",
          "getpeercred",
        ]
        in
        std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libbasu.a") symbols,
    }
}
