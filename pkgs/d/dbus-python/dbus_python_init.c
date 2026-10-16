#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <Python.h>


extern PyObject *PyInit__dbus_bindings(void);
extern PyObject *PyInit__dbus_glib_bindings(void);

__attribute__((constructor)) void python_dbus_module_init(){
    // fprintf(stderr, "initializing dbus modules\n");

    if (PyImport_AppendInittab("_dbus_bindings", PyInit__dbus_bindings) == -1){
        fprintf(stderr, "FAIL: error initializing PyInit__dbus_bindings\n");   
    }
    if (PyImport_AppendInittab("_dbus_glib_bindings", PyInit__dbus_glib_bindings) == -1){
        fprintf(stderr, "FAIL: error initializing PyInit__dbus_glib_bindings\n");   
    }

}



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

const char* lib_libc_so_6 = "lib_libc_so_6";
const char* lib__usr_lib_python3_12_site_packages_selinux__selinux_cpython_312_x86_64_linux_gnu_so = "lib__usr_lib_python3_12_site_packages_selinux__selinux_cpython_312_x86_64_linux_gnu_so";




void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "libc.so.6" ) == 0) { dbg_print("(dlopen) found library libc.so.6 (handle=%p)\n", &lib_libc_so_6); return &lib_libc_so_6; }
	// if (strcmp( path, "/usr/lib/python3.12/site-packages/selinux/_selinux.cpython-312-x86_64-linux-gnu.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/python3.12/site-packages/selinux/_selinux.cpython-312-x86_64-linux-gnu.so (handle=%p)\n", &lib__usr_lib_python3_12_site_packages_selinux__selinux_cpython_312_x86_64_linux_gnu_so); return &lib__usr_lib_python3_12_site_packages_selinux__selinux_cpython_312_x86_64_linux_gnu_so; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib_libc_so_6 || handle == NULL || handle == &main_program_handle) { 
		DLSYM(mount, )
	}


    if (strcmp(symbol,"python_dbus_module_init")==0){
        return &python_dbus_module_init;
    }
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s (handle=%p)\n", symbol, handle);	return stub_dlsym(handle, symbol);
}



int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

