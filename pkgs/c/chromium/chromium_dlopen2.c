
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#define DLSYM(sym, prefix) 	\
    if (strcmp(symbol, #sym) == 0) { \
        extern void* prefix##sym; \
		dbg_print("(dlsym) found symbol %s with handle=%p, address=%p\n", symbol, handle, &prefix##sym); \
        return &prefix##sym; \
    }

static char* dbg;
static char dbg_initualilised = 0;

static void dbg_initilialise(){
	dbg = getenv("DL_DEBUG");
	dbg_initualilised = 1;
}
static void dbg_print(const char *s, ...)
{
	if (dbg_initualilised==0){
		dbg_initilialise();
	}

    if (dbg != NULL)
    {
        va_list args;
        va_start(args, s);
        vfprintf(stderr, s, args);
    }
}

extern void *stub_dlopen(const char *, int);
extern void *stub_dlsym(void *__restrict, const char *__restrict);
extern int stub_dladdr(const void *handle, Dl_info *info);

const char* main_program_handle = "main_program";

const char* lib_libpci_so_3_libpci_so = "lib_libpci_so_3_libpci_so";
const char* lib_libEGL_so_1 = "lib_libEGL_so_1";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "libpci.so.3" ) == 0) { dbg_print("(dlopen) found library libpci.so.3 (handle=%p)\n", &lib_libpci_so_3_libpci_so); return &lib_libpci_so_3_libpci_so; }
	if (strcmp( path, "libpci.so" ) == 0) { dbg_print("(dlopen) found library libpci.so (handle=%p)\n", &lib_libpci_so_3_libpci_so); return &lib_libpci_so_3_libpci_so; }
	if (strcmp( path, "libEGL.so.1" ) == 0) { dbg_print("(dlopen) found library libEGL.so.1 (handle=%p)\n", &lib_libEGL_so_1); return &lib_libEGL_so_1; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib_libpci_so_3_libpci_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(pci_alloc, )
		DLSYM(pci_alloc_dev, )
		DLSYM(pci_cleanup, )
		DLSYM(pci_clone_access, )
		DLSYM(pci_define_param, )
		DLSYM(pci_fill_info, )
		DLSYM(pci_fill_info_v313, )
		DLSYM(pci_filter_init, )
		DLSYM(pci_filter_init_v30, )
		DLSYM(pci_filter_init_v38, )
		DLSYM(pci_filter_match, )
		DLSYM(pci_filter_match_v30, )
		DLSYM(pci_filter_match_v38, )
		DLSYM(pci_filter_parse_id, )
		DLSYM(pci_filter_parse_id_v30, )
		DLSYM(pci_filter_parse_id_v38, )
		DLSYM(pci_filter_parse_slot, )
		DLSYM(pci_filter_parse_slot_v30, )
		DLSYM(pci_filter_parse_slot_v38, )
		DLSYM(pci_find_cap, )
		DLSYM(pci_find_cap_nr, )
		DLSYM(pci_free_caps, )
		DLSYM(pci_free_dev, )
		DLSYM(pci_free_name_list, )
		DLSYM(pci_free_params, )
		DLSYM(pci_generic_block_read, )
		DLSYM(pci_generic_block_write, )
		DLSYM(pci_generic_fill_info, )
		DLSYM(pci_generic_scan, )
		DLSYM(pci_generic_scan_bus, )
		DLSYM(pci_generic_scan_domain, )
		DLSYM(pci_get_dev, )
		DLSYM(pci_get_method_name, )
		DLSYM(pci_get_param, )
		DLSYM(pci_get_string_property, )
		DLSYM(pci_id_cache_dirty, )
		DLSYM(pci_id_cache_flush, )
		DLSYM(pci_id_cache_load, )
		DLSYM(pci_id_hash_free, )
		DLSYM(pci_id_hwdb_free, )
		DLSYM(pci_id_hwdb_lookup, )
		DLSYM(pci_id_insert, )
		DLSYM(pci_id_lookup, )
		DLSYM(pci_id_net_lookup, )
		DLSYM(pci_init, )
		DLSYM(pci_init_internal, )
		DLSYM(pci_init_v35, )
		DLSYM(pci_link_dev, )
		DLSYM(pci_load_name_list, )
		DLSYM(pci_lookup_method, )
		DLSYM(pci_lookup_name, )
		DLSYM(pci_malloc, )
		DLSYM(pci_mfree, )
		DLSYM(pci_read_block, )
		DLSYM(pci_read_byte, )
		DLSYM(pci_read_long, )
		DLSYM(pci_read_vpd, )
		DLSYM(pci_read_word, )
		DLSYM(pci_scan_bus, )
		DLSYM(pci_scan_caps, )
		DLSYM(pci_set_name_list_path, )
		DLSYM(pci_set_param, )
		DLSYM(pci_set_param_internal, )
		DLSYM(pci_set_property, )
		DLSYM(pci_setup_cache, )
		DLSYM(pci_strdup, )
		DLSYM(pci_walk_params, )
		DLSYM(pci_write_block, )
		DLSYM(pci_write_byte, )
		DLSYM(pci_write_long, )
		DLSYM(pci_write_word, )
		DLSYM(physmem_access, )
		DLSYM(physmem_close, )
		DLSYM(physmem_get_pagesize, )
		DLSYM(physmem_init_config, )
		DLSYM(physmem_map, )
		DLSYM(physmem_open, )
		DLSYM(physmem_unmap, )
		DLSYM(pm_dump, )
		DLSYM(pm_ecam, )
		DLSYM(pm_intel_conf1, )
		DLSYM(pm_intel_conf2, )
		DLSYM(pm_linux_proc, )
		DLSYM(pm_linux_sysfs, )
		DLSYM(pm_mmio_conf1, )
		DLSYM(pm_mmio_conf1_ext, )
	}
	if (handle == &lib_libEGL_so_1 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(eglBindAPI, )
		DLSYM(eglBindTexImage, )
		DLSYM(eglChooseConfig, )
		DLSYM(eglClientWaitSync, )
		DLSYM(eglCopyBuffers, )
		DLSYM(eglCreateContext, )
		DLSYM(eglCreateImage, )
		DLSYM(eglCreatePbufferFromClientBuffer, )
		DLSYM(eglCreatePbufferSurface, )
		DLSYM(eglCreatePixmapSurface, )
		DLSYM(eglCreatePlatformPixmapSurface, )
		DLSYM(eglCreatePlatformWindowSurface, )
		DLSYM(eglCreateSync, )
		DLSYM(eglCreateWindowSurface, )
		DLSYM(eglDestroyContext, )
		DLSYM(eglDestroyImage, )
		DLSYM(eglDestroySurface, )
		DLSYM(eglDestroySync, )
		DLSYM(eglGetConfigAttrib, )
		DLSYM(eglGetConfigs, )
		DLSYM(eglGetCurrentContext, )
		DLSYM(eglGetCurrentDisplay, )
		DLSYM(eglGetCurrentSurface, )
		DLSYM(eglGetDisplay, )
		DLSYM(eglGetError, )
		DLSYM(eglGetPlatformDisplay, )
		DLSYM(eglGetProcAddress, )
		DLSYM(eglGetSyncAttrib, )
		DLSYM(eglInitialize, )
		DLSYM(eglMakeCurrent, )
		DLSYM(eglPrintConfigDebug, )
		DLSYM(eglQueryAPI, )
		DLSYM(eglQueryContext, )
		DLSYM(eglQueryString, )
		DLSYM(eglQuerySurface, )
		DLSYM(eglReleaseTexImage, )
		DLSYM(eglReleaseThread, )
		DLSYM(eglSurfaceAttrib, )
		DLSYM(eglSwapBuffers, )
		DLSYM(eglSwapInterval, )
		DLSYM(eglTerminate, )
		DLSYM(eglWaitClient, )
		DLSYM(eglWaitGL, )
		DLSYM(eglWaitNative, )
		DLSYM(eglWaitSync, )
	}

    DLSYM(localtime, )
    DLSYM(localtime_r, )
    // DLSYM(nspr_use_zone_allocator, )
    DLSYM(getaddrinfo, )

	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s (handle=%p)\n", symbol, handle);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

