
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

const char* lib_libEGL_so_1_libEGL_so = "lib_libEGL_so_1_libEGL_so";
const char* lib_libwayland_server_so_0 = "lib_libwayland_server_so_0";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "libEGL.so.1" ) == 0) { dbg_print("(dlopen) found library libEGL.so.1 (handle=%p)\n", &lib_libEGL_so_1_libEGL_so); return &lib_libEGL_so_1_libEGL_so; }
	if (strcmp( path, "libEGL.so" ) == 0) { dbg_print("(dlopen) found library libEGL.so (handle=%p)\n", &lib_libEGL_so_1_libEGL_so); return &lib_libEGL_so_1_libEGL_so; }
	if (strcmp( path, "libwayland-server.so.0" ) == 0) { dbg_print("(dlopen) found library libwayland-server.so.0 (handle=%p)\n", &lib_libwayland_server_so_0); return &lib_libwayland_server_so_0; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib_libEGL_so_1_libEGL_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(eglBindAPI, )
		DLSYM(eglBindTexImage, )
		DLSYM(eglBindWaylandDisplayWL, )
		DLSYM(eglChooseConfig, )
		DLSYM(eglClientWaitSync, )
		DLSYM(eglClientWaitSyncKHR, )
		DLSYM(eglCopyBuffers, )
		DLSYM(eglCreateContext, )
		DLSYM(eglCreateImage, )
		DLSYM(eglCreateImageKHR, )
		DLSYM(eglCreatePbufferFromClientBuffer, )
		DLSYM(eglCreatePbufferSurface, )
		DLSYM(eglCreatePixmapSurface, )
		DLSYM(eglCreatePlatformPixmapSurface, )
		DLSYM(eglCreatePlatformPixmapSurfaceEXT, )
		DLSYM(eglCreatePlatformWindowSurface, )
		DLSYM(eglCreatePlatformWindowSurfaceEXT, )
		DLSYM(eglCreateSync, )
		DLSYM(eglCreateSync64KHR, )
		DLSYM(eglCreateSyncKHR, )
		DLSYM(eglCreateWaylandBufferFromImageWL, )
		DLSYM(eglCreateWindowSurface, )
		DLSYM(eglDebugMessageControlKHR, )
		DLSYM(eglDestroyContext, )
		DLSYM(eglDestroyImage, )
		DLSYM(eglDestroyImageKHR, )
		DLSYM(eglDestroySurface, )
		DLSYM(eglDestroySync, )
		DLSYM(eglDestroySyncKHR, )
		DLSYM(eglDupNativeFenceFDANDROID, )
		DLSYM(eglExportDMABUFImageMESA, )
		DLSYM(eglExportDMABUFImageQueryMESA, )
		DLSYM(eglGetConfigAttrib, )
		DLSYM(eglGetConfigs, )
		DLSYM(eglGetCurrentContext, )
		DLSYM(eglGetCurrentDisplay, )
		DLSYM(eglGetCurrentSurface, )
		DLSYM(eglGetDisplay, )
		DLSYM(eglGetDisplayDriverConfig, )
		DLSYM(eglGetDisplayDriverName, )
		DLSYM(eglGetError, )
		DLSYM(eglGetMscRateANGLE, )
		DLSYM(eglGetPlatformDisplay, )
		DLSYM(eglGetPlatformDisplayEXT, )
		DLSYM(eglGetProcAddress, )
		DLSYM(eglGetSyncAttrib, )
		DLSYM(eglGetSyncAttribKHR, )
		DLSYM(eglGetSyncValuesCHROMIUM, )
		DLSYM(eglInitialize, )
		DLSYM(eglLabelObjectKHR, )
		DLSYM(eglMakeCurrent, )
		DLSYM(eglQueryAPI, )
		DLSYM(eglQueryContext, )
		DLSYM(eglQueryDebugKHR, )
		DLSYM(eglQueryDeviceAttribEXT, )
		DLSYM(eglQueryDeviceBinaryEXT, )
		DLSYM(eglQueryDeviceStringEXT, )
		DLSYM(eglQueryDevicesEXT, )
		DLSYM(eglQueryDisplayAttribEXT, )
		DLSYM(eglQueryDmaBufFormatsEXT, )
		DLSYM(eglQueryDmaBufModifiersEXT, )
		DLSYM(eglQueryString, )
		DLSYM(eglQuerySupportedCompressionRatesEXT, )
		DLSYM(eglQuerySurface, )
		DLSYM(eglQueryWaylandBufferWL, )
		DLSYM(eglReleaseTexImage, )
		DLSYM(eglReleaseThread, )
		DLSYM(eglSetBlobCacheFuncsANDROID, )
		DLSYM(eglSetDamageRegionKHR, )
		DLSYM(eglSignalSyncKHR, )
		DLSYM(eglSurfaceAttrib, )
		DLSYM(eglSwapBuffers, )
		DLSYM(eglSwapBuffersWithDamageEXT, )
		DLSYM(eglSwapBuffersWithDamageKHR, )
		DLSYM(eglSwapInterval, )
		DLSYM(eglTerminate, )
		DLSYM(eglUnbindWaylandDisplayWL, )
		DLSYM(eglWaitClient, )
		DLSYM(eglWaitGL, )
		DLSYM(eglWaitNative, )
		DLSYM(eglWaitSync, )
		DLSYM(eglWaitSyncKHR, )
		DLSYM(eglPrintConfigDebug, )
	}
	if (handle == &lib_libwayland_server_so_0 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(wl_display_set_default_max_buffer_size, )
	}
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

