

def replace(p, old, new):
    with open(p) as f:
        s = f.read()


    s = s.replace(old,
    new
    )

    with open(p, "w") as f:
        f.write(s)


replace("base/allocator/partition_allocator/src/partition_alloc/shim/allocator_shim_default_dispatch_to_partition_alloc.cc",
"""#if PA_BUILDFLAG(IS_LINUX) || PA_BUILDFLAG(IS_CHROMEOS)
SHIM_ALWAYS_EXPORT struct mallinfo mallinfo(void) __THROW {""",
"""#if 0 // PA_BUILDFLAG(IS_LINUX) || PA_BUILDFLAG(IS_CHROMEOS)
SHIM_ALWAYS_EXPORT struct mallinfo mallinfo(void) __THROW {"""
)

replace("net/dns/public/scoped_res_state.cc",
"""ScopedResState::ScopedResState() {
#if BUILDFLAG(IS_OPENBSD) || BUILDFLAG(IS_FUCHSIA)""",
"""ScopedResState::ScopedResState() {
#if BUILDFLAG(IS_OPENBSD) || BUILDFLAG(IS_FUCHSIA) || defined(_GNU_SOURCE)"""
)

replace("base/trace_event/malloc_dump_provider.cc",
"""#if defined(__GLIBC__) && defined(__GLIBC_PREREQ)
#if __GLIBC_PREREQ(2, 33)
#define MALLINFO2_FOUND_IN_LIBC
  struct mallinfo2 info = mallinfo2();
#endif
#endif  // defined(__GLIBC__) && defined(__GLIBC_PREREQ)
#if !defined(MALLINFO2_FOUND_IN_LIBC)
  struct mallinfo info = mallinfo();
#endif
#undef MALLINFO2_FOUND_IN_LIBC
  // In case of Android's jemalloc |arena| is 0 and the outer pages size is
  // reported by |hblkhd|. In case of dlmalloc the total is given by
  // |arena| + |hblkhd|. For more details see link: http://goo.gl/fMR8lF.
  *total_virtual_size += checked_cast<size_t>(info.arena + info.hblkhd);
  size_t total_allocated_size = checked_cast<size_t>(info.uordblks);
  *resident_size += total_allocated_size;

  // Total allocated space is given by |uordblks|.
  *allocated_objects_size += total_allocated_size;

  if (pmd) {
    MemoryAllocatorDump* sys_alloc_dump =
        pmd->CreateAllocatorDump("malloc/sys_malloc");
    sys_alloc_dump->AddScalar(MemoryAllocatorDump::kNameSize,
                              MemoryAllocatorDump::kUnitsBytes,
                              total_allocated_size);
  }""",""
)


replace("base/process/process_metrics_posix.cc",
'''#if BUILDFLAG(IS_LINUX) || BUILDFLAG(IS_CHROMEOS) || BUILDFLAG(IS_ANDROID)
namespace {

size_t GetMallocUsageMallinfo() {
#if defined(__GLIBC__) && defined(__GLIBC_PREREQ)
#if __GLIBC_PREREQ(2, 33)
#define MALLINFO2_FOUND_IN_LIBC
  struct mallinfo2 minfo = mallinfo2();
#endif
#endif  // defined(__GLIBC__) && defined(__GLIBC_PREREQ)
#if !defined(MALLINFO2_FOUND_IN_LIBC)
  struct mallinfo minfo = mallinfo();
#endif
#undef MALLINFO2_FOUND_IN_LIBC
  return checked_cast<size_t>(minfo.hblkhd + minfo.arena);
}

}  // namespace
#endif  // BUILDFLAG(IS_LINUX) || BUILDFLAG(IS_CHROMEOS) ||
        // BUILDFLAG(IS_ANDROID)

size_t ProcessMetrics::GetMallocUsage() {
#if BUILDFLAG(IS_APPLE)
  malloc_statistics_t stats = {0};
  malloc_zone_statistics(nullptr, &stats);
  return stats.size_in_use;
#elif BUILDFLAG(IS_LINUX) || BUILDFLAG(IS_CHROMEOS) || BUILDFLAG(IS_ANDROID)
  return GetMallocUsageMallinfo();
#elif BUILDFLAG(IS_FUCHSIA)
  // TODO(fuchsia): Not currently exposed. https://crbug.com/735087.
  return 0;
#endif
}''',
'''#if 0
namespace {

size_t GetMallocUsageMallinfo() {
#if defined(__GLIBC__) && defined(__GLIBC_PREREQ)
#if __GLIBC_PREREQ(2, 33)
#define MALLINFO2_FOUND_IN_LIBC
  struct mallinfo2 minfo = mallinfo2();
#endif
#endif  // defined(__GLIBC__) && defined(__GLIBC_PREREQ)
#if !defined(MALLINFO2_FOUND_IN_LIBC)
  struct mallinfo minfo = mallinfo();
#endif
#undef MALLINFO2_FOUND_IN_LIBC
  return checked_cast<size_t>(minfo.hblkhd + minfo.arena);
}

}  // namespace
#endif  // BUILDFLAG(IS_LINUX) || BUILDFLAG(IS_CHROMEOS) ||
        // BUILDFLAG(IS_ANDROID)

size_t ProcessMetrics::GetMallocUsage() {
#if BUILDFLAG(IS_APPLE)
  malloc_statistics_t stats = {0};
  malloc_zone_statistics(nullptr, &stats);
  return stats.size_in_use;
#elif 0
  return GetMallocUsageMallinfo();
#else
  // TODO(fuchsia): Not currently exposed. https://crbug.com/735087.
  return 0;
#endif
}'''
)


replace("mojo/public/cpp/bindings/clone_traits.h",
'''template <typename T>
struct CloneTraits<std::optional<T>> {
  static std::optional<T> Clone(const std::optional<T>& input) {
    if (!input) {
      return std::nullopt;
    }

    return std::optional<T>(mojo::Clone(*input));
  }
};''',
'''
template <typename T>
struct CloneTraits<std::optional<T>> {
  static std::optional<T> Clone(const std::optional<T>& input) {
    if (!input) {
      return std::nullopt;
    }

    return std::optional<T>(mojo::Clone(*input));
  }
};

template <>
struct CloneTraits<std::vector<bool>> {
  static std::vector<bool> Clone(const std::vector<bool>& input) {
    // std::vector<bool> res;
    // for (bool b : input){
    //  res.push_back(b);
    // }
    return input;
  }
};'''
)


# replace("base/allocator/partition_allocator/src/partition_alloc/pointers/raw_ref.h",
# '''template <typename T, base::RawPtrTraits Traits>
# struct less<raw_ref<T, Traits>> {
#   using Impl = typename raw_ref<T, Traits>::Impl;
#   using is_transparent = void;

#   bool operator()(const raw_ref<T, Traits>& lhs,
#                   const raw_ref<T, Traits>& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }

#   bool operator()(T& lhs, const raw_ref<T, Traits>& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }

#   bool operator()(const raw_ref<T, Traits>& lhs, T& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }
# };''',
# '''template <typename T, base::RawPtrTraits Traits>
# struct less<raw_ref<T, Traits>> {
#   using Impl = typename raw_ref<T, Traits>::Impl;
#   using is_transparent = void;

#   bool operator()(const raw_ref<T, Traits>& lhs,
#                   const raw_ref<T, Traits>& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }

#   bool operator()(T& lhs, const raw_ref<T, Traits>& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }

#   bool operator()(const raw_ref<T, Traits>& lhs, T& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }

#   // Added
#   bool operator()(const T& lhs, const raw_ref<T, Traits>& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }

#   bool operator()(const raw_ref<T, Traits>& lhs, const T& rhs) const {
#     Impl::IncrementLessCountForTest();
#     return lhs < rhs;
#   }
# };'''
# )


# replace("components/permissions/permission_request_manager.cc",
# '''bool PermissionRequestManager::
#     HasActiveSourceFrameOrDisallowActivationOtherwise(
#         const PermissionRequest& request) const {
#   const auto iter = request_sources_map_.find(request);
#   if (iter != request_sources_map_.end()) {
#     return !iter->second.IsSourceFrameInactiveAndDisallowActivation();
#   }
#   return false;
# }''',
# '''bool PermissionRequestManager::
#     HasActiveSourceFrameOrDisallowActivationOtherwise(
#         const PermissionRequest& request) const {
#   const auto iter = request_sources_map_.find(request);
#   if (iter != request_sources_map_.end()) {
#     return !iter->second.IsSourceFrameInactiveAndDisallowActivation();
#   }
#   return false;
# }'''
# )


replace("components/enterprise/client_certificates/core/private_key_factory.cc",
'''++std::find(std::begin(kKeySourcesOrderedBySecurity),
                         std::end(kKeySourcesOrderedBySecurity), source)''',
'''std::find(std::begin(kKeySourcesOrderedBySecurity),
                         std::end(kKeySourcesOrderedBySecurity), source) + 1'''
)

replace("services/device/public/cpp/generic_sensor/sensor_reading_shared_buffer_reader.cc",
'''std::atomic_ref(const_cast<SensorReading&>(buffer->reading))
                  .load(std::memory_order_relaxed);''',
'buffer->reading;'
)


replace("services/device/generic_sensor/platform_sensor.cc",
'''std::atomic_ref(reading_buffer_->reading)
      .store(reading, std::memory_order_relaxed);''',
'reading_buffer_->reading;'

)


replace("base/files/scoped_file_linux.cc",
'''#if !defined(COMPONENT_BUILD)
using LibcCloseFuncPtr = int (*)(int);''',

'''#if 0
using LibcCloseFuncPtr = int (*)(int);'''
)


# replace("chrome/BUILD.gn",
# "if (!(is_debug && use_debug_fission)) {",
# "if (false) {"
# )


# replace("chrome/BUILD.gn",
# '":angle_egl_symbols",'
# '')
# replace("chrome/BUILD.gn",
# '":angle_gles_symbols",'
# '')

# replace("chrome/BUILD.gn",
# '''
#     extract_symbols("angle_egl_symbols") {
#       binary = "$root_out_dir/libEGL.so"

#       if (current_cpu == "x86") {
#         # GYP used "ia32" so keep that naming for back-compat.
#         symbol_file = "$root_out_dir/angle_libegl.breakpad.ia32"
#       } else {
#         symbol_file = "$root_out_dir/angle_libegl.breakpad.$current_cpu"
#       }

#       if (use_static_angle) {
#         deps = [ "//ui/gl:dummy_libEGL" ]
#       } else {
#         deps = [ "//third_party/angle:libEGL" ]
#       }
#     }
#     extract_symbols("angle_gles_symbols") {
#       binary = "$root_out_dir/libGLESv2.so"

#       if (current_cpu == "x86") {
#         # GYP used "ia32" so keep that naming for back-compat.
#         symbol_file = "$root_out_dir/angle_libgles.breakpad.ia32"
#       } else {
#         symbol_file = "$root_out_dir/angle_libgles.breakpad.$current_cpu"
#       }

#       if (use_static_angle) {
#         deps = [ "//ui/gl:dummy_libGLESv2" ]
#       } else {
#         deps = [ "//third_party/angle:libGLESv2" ]
#       }
#     }''',''
# )

replace("sandbox/linux/services/libc_interceptor.cc",
'''__attribute__((__visibility__("default"))) struct tm* localtime_override(
    const time_t* timep) __asm__("localtime");''',
'''// __attribute__((__visibility__("default"))) struct tm* localtime_override(
//     const time_t* timep) __asm__("localtime");'''
)

replace("sandbox/linux/services/libc_interceptor.cc",
'''__attribute__((__visibility__("default"))) struct tm* localtime_r_override(
    const time_t* timep,
    struct tm* result) __asm__("localtime_r");''',
'''// __attribute__((__visibility__("default"))) struct tm* localtime_r_override(
//     const time_t* timep,
//     struct tm* result) __asm__("localtime_r");'''
    )

def dquote(s):
    return f'"{s}"'

libs=[
    "/tmp/workdir/src/libdl_chromium.a", 
    "/usr/lib/libgcm.a", 
    "/usr/lib/libhw-acc-crypto-avx2.a", 
    "/usr/lib/libhw-acc-crypto-avx.a", 
    "/usr/lib/libghash-aes-x86_c_lib.a",
    "/usr/lib/libsha-x86_c_lib.a",
    "/usr/lib/libintel-gcm-wrap_c_lib.a", 
    "/usr/lib/libfreebl_static.a", 
    "/usr/lib/libsqlite.a", 
    "/usr/lib/libpk11wrap.a", 
    "/usr/lib/libEGL.a", 
    "/usr/lib/libpci.a", 
    "/usr/lib/libplds4.a", 
    "/usr/lib/libplc4.a", 
    "/usr/lib/libsoftokn.a" 
    ]

libs_str=",".join([dquote(l) for l in libs])
replace("chrome/BUILD.gn",
"ldflags = []",
f'ldflags = [{libs_str}]'
)
