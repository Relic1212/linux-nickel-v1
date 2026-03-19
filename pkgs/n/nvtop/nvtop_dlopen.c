
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

const char* lib_libdrm_so = "lib_libdrm_so";
const char* lib_libdrm_amdgpu_so = "lib_libdrm_amdgpu_so";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "libdrm.so" ) == 0) { dbg_print("(dlopen) found library libdrm.so (handle=%p)\n", &lib_libdrm_so); return &lib_libdrm_so; }
	if (strcmp( path, "libdrm_amdgpu.so" ) == 0) { dbg_print("(dlopen) found library libdrm_amdgpu.so (handle=%p)\n", &lib_libdrm_amdgpu_so); return &lib_libdrm_amdgpu_so; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib_libdrm_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(drmGetDevices2, )
		DLSYM(drmGetDevices, )
		DLSYM(drmFreeDevices, )
		DLSYM(drmGetVersion, )
		DLSYM(drmFreeVersion, )
		DLSYM(drmGetMagic, )
		DLSYM(drmAuthMagic, )
		DLSYM(drmDropMaster, )
		DLSYM(drmCommandWriteRead, )
		DLSYM(drmGetDeviceFromDevId, )
		DLSYM(drmIoctl, )
	}
	if (handle == &lib_libdrm_amdgpu_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(amdgpu_device_initialize, )
		DLSYM(amdgpu_device_deinitialize, )
		DLSYM(amdgpu_get_marketing_name, )
		DLSYM(amdgpu_query_hw_ip_info, )
		DLSYM(amdgpu_query_info, )
		DLSYM(amdgpu_query_gpu_info, )
		DLSYM(amdgpu_query_sensor_info, )
	}
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

