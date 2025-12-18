
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




static char *dbg;
static char dbg_initualilised = 0;

static void dbg_initilialise()
{
	dbg = getenv("DL_DEBUG");
	dbg_initualilised = 1;
}
static void dbg_print(const char *s, ...)
{
	if (dbg_initualilised == 0)
	{
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

const char *main_program_handle = "main_program";

const char *lib__usr_lib_libborders_plus_plus_so = "lib__usr_lib_libborders_plus_plus_so";
const char *lib__usr_lib_libhyprexpo_so = "lib__usr_lib_libhyprexpo_so";
const char *lib__usr_lib_libhyprscrolling_so = "lib__usr_lib_libhyprscrolling_so";
const char *lib__usr_lib_libhyprbars_so = "lib__usr_lib_libhyprbars_so";
const char *lib__usr_lib_libxtra_dispatchers_so = "lib__usr_lib_libxtra_dispatchers_so";
const char *lib__usr_lib_libhyprfocus_so = "lib__usr_lib_libhyprfocus_so";
const char *lib__usr_lib_libHyprspace_so = "lib__usr_lib_libHyprspace_so";

void *dlopen(const char *path, int mode)
{
	if (path == NULL)
	{
		return &main_program_handle;
	}
	if (strcmp(path, "/usr/lib/libborders-plus-plus.so") == 0)
	{
		dbg_print("(dlopen) found library /usr/lib/libborders-plus-plus.so (handle=%p)\n", &lib__usr_lib_libborders_plus_plus_so);
		return &lib__usr_lib_libborders_plus_plus_so;
	}
	if (strcmp(path, "/usr/lib/libhyprexpo.so") == 0)
	{
		dbg_print("(dlopen) found library /usr/lib/libhyprexpo.so (handle=%p)\n", &lib__usr_lib_libhyprexpo_so);
		return &lib__usr_lib_libhyprexpo_so;
	}
	if (strcmp(path, "/usr/lib/libhyprscrolling.so") == 0)
	{
		dbg_print("(dlopen) found library /usr/lib/libhyprscrolling.so (handle=%p)\n", &lib__usr_lib_libhyprscrolling_so);
		return &lib__usr_lib_libhyprscrolling_so;
	}
	if (strcmp(path, "/usr/lib/libhyprbars.so") == 0)
	{
		dbg_print("(dlopen) found library /usr/lib/libhyprbars.so (handle=%p)\n", &lib__usr_lib_libhyprbars_so);
		return &lib__usr_lib_libhyprbars_so;
	}
	if (strcmp(path, "/usr/lib/libxtra-dispatchers.so") == 0)
	{
		dbg_print("(dlopen) found library /usr/lib/libxtra-dispatchers.so (handle=%p)\n", &lib__usr_lib_libxtra_dispatchers_so);
		return &lib__usr_lib_libxtra_dispatchers_so;
	}
	if (strcmp(path, "/usr/lib/libhyprfocus.so") == 0)
	{
		dbg_print("(dlopen) found library /usr/lib/libhyprfocus.so (handle=%p)\n", &lib__usr_lib_libhyprfocus_so);
		return &lib__usr_lib_libhyprfocus_so;
	}
	if (strcmp(path, "/usr/lib/libHyprspace.so") == 0)
	{
		dbg_print("(dlopen) found library /usr/lib/libHyprspace.so (handle=%p)\n", &lib__usr_lib_libHyprspace_so);
		return &lib__usr_lib_libHyprspace_so;
	}
	fprintf(stderr, "(dlopen) WARNING: failed for path %s\n", path);
	return stub_dlopen(path, mode);
}

void *dlsym(void *__restrict handle, const char *__restrict symbol)
{
	if (handle == &lib__usr_lib_libborders_plus_plus_so || handle == NULL || handle == &main_program_handle)
	{
		if (strcmp(symbol, "pluginAPIVersion") == 0)
		{
			extern void *borders_plus_plus_pluginAPIVersion;
			dbg_print("(dlsym) found symbol pluginAPIVersion with handle=%p, address=%p\n", handle, &borders_plus_plus_pluginAPIVersion);
			return &borders_plus_plus_pluginAPIVersion;
		}
		if (strcmp(symbol, "pluginExit") == 0)
		{
			extern void *borders_plus_plus_pluginExit;
			dbg_print("(dlsym) found symbol pluginExit with handle=%p, address=%p\n", handle, &borders_plus_plus_pluginExit);
			return &borders_plus_plus_pluginExit;
		}
		if (strcmp(symbol, "pluginInit") == 0)
		{
			extern void *borders_plus_plus_pluginInit;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &borders_plus_plus_pluginInit);
			return &borders_plus_plus_pluginInit;
		}
	}
	if (handle == &lib__usr_lib_libhyprexpo_so || handle == NULL || handle == &main_program_handle)
	{
		if (strcmp(symbol, "pluginAPIVersion") == 0)
		{
			extern void *hyprexpo_pluginAPIVersion;
			dbg_print("(dlsym) found symbol pluginAPIVersion with handle=%p, address=%p\n", handle, &hyprexpo_pluginAPIVersion);
			return &hyprexpo_pluginAPIVersion;
		}
		if (strcmp(symbol, "pluginExit") == 0)
		{
			extern void *hyprexpo_pluginExit;
			dbg_print("(dlsym) found symbol pluginExit with handle=%p, address=%p\n", handle, &hyprexpo_pluginExit);
			return &hyprexpo_pluginExit;
		}
		if (strcmp(symbol, "pluginInit") == 0)
		{
			extern void *hyprexpo_pluginInit;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &hyprexpo_pluginInit);
			return &hyprexpo_pluginInit;
		}
        if (strcmp(symbol, "_ZN13CHyprRenderer15renderWorkspaceEN9Hyprutils6Memory14CSharedPointerI8CMonitorEENS2_I10CWorkspaceEERKNSt3__16chrono10time_pointINS8_12steady_clockENS8_8durationIxNS7_5ratioILl1ELl1000000000EEEEEEERKNS0_4Math4CBoxE") == 0)
		{
			extern void *_ZN13CHyprRenderer15renderWorkspaceEN9Hyprutils6Memory14CSharedPointerI8CMonitorEENS2_I10CWorkspaceEERKNSt3__16chrono10time_pointINS8_12steady_clockENS8_8durationIxNS7_5ratioILl1ELl1000000000EEEEEEERKNS0_4Math4CBoxE;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &_ZN13CHyprRenderer15renderWorkspaceEN9Hyprutils6Memory14CSharedPointerI8CMonitorEENS2_I10CWorkspaceEERKNSt3__16chrono10time_pointINS8_12steady_clockENS8_8durationIxNS7_5ratioILl1ELl1000000000EEEEEEERKNS0_4Math4CBoxE);
			return &_ZN13CHyprRenderer15renderWorkspaceEN9Hyprutils6Memory14CSharedPointerI8CMonitorEENS2_I10CWorkspaceEERKNSt3__16chrono10time_pointINS8_12steady_clockENS8_8durationIxNS7_5ratioILl1ELl1000000000EEEEEEERKNS0_4Math4CBoxE;
		}
        if (strcmp(symbol, "_ZN8CMonitor9addDamageEPK15pixman_region32") == 0)
		{
			extern void *_ZN8CMonitor9addDamageEPK15pixman_region32;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &_ZN8CMonitor9addDamageEPK15pixman_region32);
			return &_ZN8CMonitor9addDamageEPK15pixman_region32;
		}
        if (strcmp(symbol, "_ZN8CMonitor9addDamageERKN9Hyprutils4Math4CBoxE") == 0)
		{
			extern void *_ZN8CMonitor9addDamageERKN9Hyprutils4Math4CBoxE;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &_ZN8CMonitor9addDamageERKN9Hyprutils4Math4CBoxE);
			return &_ZN8CMonitor9addDamageERKN9Hyprutils4Math4CBoxE;
		}
	}
	if (handle == &lib__usr_lib_libhyprscrolling_so || handle == NULL || handle == &main_program_handle)
	{
		if (strcmp(symbol, "pluginAPIVersion") == 0)
		{
			extern void *hyprscrolling_pluginAPIVersion;
			dbg_print("(dlsym) found symbol pluginAPIVersion with handle=%p, address=%p\n", handle, &hyprscrolling_pluginAPIVersion);
			return &hyprscrolling_pluginAPIVersion;
		}
		if (strcmp(symbol, "pluginExit") == 0)
		{
			extern void *hyprscrolling_pluginExit;
			dbg_print("(dlsym) found symbol pluginExit with handle=%p, address=%p\n", handle, &hyprscrolling_pluginExit);
			return &hyprscrolling_pluginExit;
		}
		if (strcmp(symbol, "pluginInit") == 0)
		{
			extern void *hyprscrolling_pluginInit;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &hyprscrolling_pluginInit);
			return &hyprscrolling_pluginInit;
		}
	}
	if (handle == &lib__usr_lib_libhyprbars_so || handle == NULL || handle == &main_program_handle)
	{
		if (strcmp(symbol, "pluginAPIVersion") == 0)
		{
			extern void *hyprbars_pluginAPIVersion;
			dbg_print("(dlsym) found symbol pluginAPIVersion with handle=%p, address=%p\n", handle, &hyprbars_pluginAPIVersion);
			return &hyprbars_pluginAPIVersion;
		}
		if (strcmp(symbol, "pluginExit") == 0)
		{
			extern void *hyprbars_pluginExit;
			dbg_print("(dlsym) found symbol pluginExit with handle=%p, address=%p\n", handle, &hyprbars_pluginExit);
			return &hyprbars_pluginExit;
		}
		if (strcmp(symbol, "pluginInit") == 0)
		{
			extern void *hyprbars_pluginInit;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &hyprbars_pluginInit);
			return &hyprbars_pluginInit;
		}
	}
	if (handle == &lib__usr_lib_libxtra_dispatchers_so || handle == NULL || handle == &main_program_handle)
	{
		if (strcmp(symbol, "pluginAPIVersion") == 0)
		{
			extern void *xtra_dispatchers_pluginAPIVersion;
			dbg_print("(dlsym) found symbol pluginAPIVersion with handle=%p, address=%p\n", handle, &xtra_dispatchers_pluginAPIVersion);
			return &xtra_dispatchers_pluginAPIVersion;
		}
		if (strcmp(symbol, "pluginExit") == 0)
		{
			extern void *xtra_dispatchers_pluginExit;
			dbg_print("(dlsym) found symbol pluginExit with handle=%p, address=%p\n", handle, &xtra_dispatchers_pluginExit);
			return &xtra_dispatchers_pluginExit;
		}
		if (strcmp(symbol, "pluginInit") == 0)
		{
			extern void *xtra_dispatchers_pluginInit;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &xtra_dispatchers_pluginInit);
			return &xtra_dispatchers_pluginInit;
		}
	}
	if (handle == &lib__usr_lib_libhyprfocus_so || handle == NULL || handle == &main_program_handle)
	{
		if (strcmp(symbol, "pluginAPIVersion") == 0)
		{
			extern void *hyprfocus_pluginAPIVersion;
			dbg_print("(dlsym) found symbol pluginAPIVersion with handle=%p, address=%p\n", handle, &hyprfocus_pluginAPIVersion);
			return &hyprfocus_pluginAPIVersion;
		}
		if (strcmp(symbol, "pluginExit") == 0)
		{
			extern void *hyprfocus_pluginExit;
			dbg_print("(dlsym) found symbol pluginExit with handle=%p, address=%p\n", handle, &hyprfocus_pluginExit);
			return &hyprfocus_pluginExit;
		}
		if (strcmp(symbol, "pluginInit") == 0)
		{
			extern void *hyprfocus_pluginInit;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &hyprfocus_pluginInit);
			return &hyprfocus_pluginInit;
		}
	}
	if (handle == &lib__usr_lib_libHyprspace_so || handle == NULL || handle == &main_program_handle)
	{
		if (strcmp(symbol, "pluginAPIVersion") == 0)
		{
			extern void *Hyprspace_pluginAPIVersion;
			dbg_print("(dlsym) found symbol pluginAPIVersion with handle=%p, address=%p\n", handle, &Hyprspace_pluginAPIVersion);
			return &Hyprspace_pluginAPIVersion;
		}
		if (strcmp(symbol, "pluginExit") == 0)
		{
			extern void *Hyprspace_pluginExit;
			dbg_print("(dlsym) found symbol pluginExit with handle=%p, address=%p\n", handle, &Hyprspace_pluginExit);
			return &Hyprspace_pluginExit;
		}
		if (strcmp(symbol, "pluginInit") == 0)
		{
			extern void *Hyprspace_pluginInit;
			dbg_print("(dlsym) found symbol pluginInit with handle=%p, address=%p\n", handle, &Hyprspace_pluginInit);
			return &Hyprspace_pluginInit;
		}

		DLSYM(_ZN15CKeybindManager5mouseENSt3__112basic_stringIcNS0_11char_traitsIcEENS0_9allocatorIcEEEE,)
		DLSYM(_ZN13CHyprRenderer12renderWindowEN9Hyprutils6Memory14CSharedPointerI7CWindowEENS2_I8CMonitorEERKNSt3__16chrono10time_pointINS8_12steady_clockENS8_8durationIxNS7_5ratioILl1ELl1000000000EEEEEEEb15eRenderPassModebb,)
		DLSYM(_ZN13CHyprRenderer11renderLayerEN9Hyprutils6Memory14CSharedPointerI13CLayerSurfaceEENS2_I8CMonitorEERKNSt3__16chrono10time_pointINS8_12steady_clockENS8_8durationIxNS7_5ratioILl1ELl1000000000EEEEEEEbb,)
	}
	fprintf(stderr, "(dlsym) WARNING: failed for symbol %s\n", symbol);
	return stub_dlsym(handle, symbol);
}

int dladdr(const void *handle, Dl_info *info)
{
	fprintf(stderr, "(dladdr) handle=\"%p\"\n", handle);
	return stub_dladdr(handle, info);
}
