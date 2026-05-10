
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

const char* lib__usr_lib_tinysparql_3_0_libtracker_http_soup3_so = "lib__usr_lib_tinysparql_3_0_libtracker_http_soup3_so";
const char* lib__usr_lib_tinysparql_3_0_libtracker_parser_libicu_so = "lib__usr_lib_tinysparql_3_0_libtracker_parser_libicu_so";

void* dlopen(const char *path, int mode) {
	if (path == NULL) { return &main_program_handle; }
	if (strcmp( path, "/usr/lib/tinysparql-3.0/libtracker-http-soup3.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/tinysparql-3.0/libtracker-http-soup3.so (handle=%p)\n", &lib__usr_lib_tinysparql_3_0_libtracker_http_soup3_so); return &lib__usr_lib_tinysparql_3_0_libtracker_http_soup3_so; }
	if (strcmp( path, "/usr/lib/tinysparql-3.0/libtracker-parser-libicu.so" ) == 0) { dbg_print("(dlopen) found library /usr/lib/tinysparql-3.0/libtracker-parser-libicu.so (handle=%p)\n", &lib__usr_lib_tinysparql_3_0_libtracker_parser_libicu_so); return &lib__usr_lib_tinysparql_3_0_libtracker_parser_libicu_so; }
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);	return stub_dlopen(path, mode);
}

void* dlsym(void *__restrict handle, const char *__restrict symbol) {
	if (handle == &lib__usr_lib_tinysparql_3_0_libtracker_http_soup3_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(initialize_types, tracker_http_soup3__)
		DLSYM(print_parameter_entry, tracker_http_soup3__)
		DLSYM(tracker_get_debug_flags, tracker_http_soup3__)
		DLSYM(tracker_http_client_get_type, tracker_http_soup3__)
		DLSYM(tracker_http_client_soup_get_type, tracker_http_soup3__)
		DLSYM(tracker_http_server_get_type, tracker_http_soup3__)
		DLSYM(tracker_http_server_soup_get_type, tracker_http_soup3__)
	}
	if (handle == &lib__usr_lib_tinysparql_3_0_libtracker_parser_libicu_so || handle == NULL || handle == &main_program_handle) { 
		DLSYM(tracker_collation_init, tracker_parser_icu__)
		DLSYM(tracker_collation_shutdown, tracker_parser_icu__)
		DLSYM(tracker_collation_utf8, tracker_parser_icu__)
		DLSYM(tracker_parser_casefold, tracker_parser_icu__)
		DLSYM(tracker_parser_free, tracker_parser_icu__)
		DLSYM(tracker_parser_new, tracker_parser_icu__)
		DLSYM(tracker_parser_next, tracker_parser_icu__)
		DLSYM(tracker_parser_normalize, tracker_parser_icu__)
		DLSYM(tracker_parser_reset, tracker_parser_icu__)
		DLSYM(tracker_parser_tolower, tracker_parser_icu__)
		DLSYM(tracker_parser_toupper, tracker_parser_icu__)
		DLSYM(tracker_parser_unaccent, tracker_parser_icu__)
		DLSYM(tracker_language_get_type, tracker_parser_icu__)
		DLSYM(tracker_language_new, tracker_parser_icu__)
		DLSYM(tracker_language_stem_word, tracker_parser_icu__)
	}
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);	return stub_dlsym(handle, symbol);
}


int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
    return stub_dladdr(handle, info);
}

