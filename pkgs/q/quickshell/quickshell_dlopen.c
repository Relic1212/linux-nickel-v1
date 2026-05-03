
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

const char* lib_libpipewire_0_3_so_0 = "lib_libpipewire_0_3_so_0";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "libpipewire-0.3.so.0" ) == 0) { dbg_print("(dlopen) found library libpipewire-0.3.so.0 (handle=%p)\n", &lib_libpipewire_0_3_so_0); return &lib_libpipewire_0_3_so_0; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib_libpipewire_0_3_so_0 || handle == NULL || handle == &main_program_handle) { 
		dbg_print("(dlsym) looking in library libpipewire-0.3.so.0 (address=%p)\n", handle);
		DLSYM(spa_log_topic_enum, )
		DLSYM(pw_init, )
		DLSYM(pw_deinit, )
		DLSYM(pw_check_library_version, )
		DLSYM(pw_context_new, )
		DLSYM(pw_context_destroy, )
		DLSYM(pw_context_connect, )
		DLSYM(pw_context_connect_fd, );
		DLSYM(pw_core_disconnect, );
		DLSYM(pw_thread_loop_new, );
		DLSYM(pw_thread_loop_destroy, );
		DLSYM(pw_thread_loop_get_loop, );
		DLSYM(pw_thread_loop_start, );
		DLSYM(pw_thread_loop_stop, );
		DLSYM(pw_thread_loop_lock, );
		DLSYM(pw_thread_loop_unlock, );
		DLSYM(pw_thread_loop_timed_wait, );
		DLSYM(pw_thread_loop_signal, );
		DLSYM(pw_thread_loop_in_thread, );
		DLSYM(pw_properties_new_dict, );
		DLSYM(pw_properties_free, );
		DLSYM(pw_stream_new, );
		DLSYM(pw_stream_new_simple, );
		DLSYM(pw_stream_destroy, );
		DLSYM(pw_stream_add_listener, );
		DLSYM(pw_stream_connect, );
		DLSYM(pw_stream_disconnect, );
		DLSYM(pw_stream_set_active, );
		DLSYM(pw_stream_dequeue_buffer, );
		DLSYM(pw_stream_queue_buffer, );
		DLSYM(pw_stream_get_time_n, );
		DLSYM(pw_proxy_destroy, );
		DLSYM(pw_get_library_version, );

	}
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

