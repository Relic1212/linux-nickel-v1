#!/usr/bin/env python

import subprocess


# abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_
def get_alphabet():
    s = ""
    for i in range(97, 123):
        s += chr(i)
    s += s.upper()
    for i in range(10):
        s += str(i)
    s += "_"
    return s


def is_symbol_name(sym: str):
    if sym[0] in "0123456789":
        return False
    a = get_alphabet()
    for s in sym:
        if not s in a:
            return False
    return True


def replace_chars(s):
    alph = get_alphabet()
    s_out = ""
    for c in s:
        if c in alph:
            s_out += c
        else:
            s_out += "_"
    return s_out


class PluginLibrary:

    def __init__(self, names, prefix="", symbols=None):
        self.names = names
        if symbols is None:
            symbols = []
        self.symbols = symbols
        self.prefix = prefix

    def get_libname(self) -> str:
        libname = f"lib_{"_".join(replace_chars(l) for l in self.names)}"
        return libname

    def add_name(self, name: str) -> None:
        self.names.append(name)

    def add_symbol(self, symbol: str) -> None:
        self.symbols.append(symbol)

    def extern_c_source(self) -> str:
        s = ""
        libname = self.get_libname()
        s += f"const char* {libname} = \"{libname}\";\n"
        # for sym in self.symbols:
        #     s += f"extern void* {sym};\n"
        return s

    def dlopen_c_source(self) -> str:
        s = ""
        for name in self.names:
            s += "\tif (strcmp( path, \"%s\" ) == 0) { dbg_print(\"(dlopen) found library %s (handle=%s)\\n\", &%s); return &%s; }\n" % (
                name, name, '%'+'p', self.get_libname(), self.get_libname())
        return s

    def dlsym_c_source(self) -> str:
        s = ""
        # % (self.get_libname())
        s += f"\tif (handle == &{self.get_libname()} || handle == NULL || handle == &main_program_handle) {{ \n"
        # s += f"\tdlsym_debug_library_name = \"{self.names[0]}\";\n"
        for sym in self.symbols:
            assert (sym.startswith(self.prefix))
            sym_str = sym[len(self.prefix):]

            # dbg_s =  'dbg_print("(dlsym) found symbol %s with handle=%%p, address=%%p\\n", handle, &%s);' % ( sym_str, sym)
            # s += "\t\tif (strcmp(symbol, \"%s\") == 0) { extern void* %s; %s return &%s; }\n" % (    sym_str, sym, dbg_s, sym)
            s += f"\t\tDLSYM({sym_str}, {self.prefix})\n"
        s += "\t}\n"
        return s

    def dlsym_c_dbg_source(self) -> str:
        s = ""
        if len(self.names) > 0:
            s += f"\telse if (handle == &{{{self.get_libname()}}}) {{ "
            s += f" dlsym_debug_library_name = \"{self.names[0]}\"; "
            s += " }\n"
        return s


def get_lib_syms(libpath: str) -> list[str]:
    syms = []
    cmd = ["llvm-nm", "--defined-only", "--extern-only",
           libpath]
    print(f"// running {" ".join(cmd)}")
    try:
        r = subprocess.run(cmd, capture_output=True, check=False)
        if r.returncode != 0:
            raise Exception()
    except Exception as e:
        try:
            print(r.stderr.decode())
            print(r.stdout.decode())
        except UnboundLocalError:
            pass
        raise e
    lines = r.stdout.decode().split("\n")
    for line in lines:
        if line == "":
            continue
        try:
            ls = line.strip().split()

            print(f"ls={ls}")
            if len(ls) < 2:
                continue
            sn = ls[-1]
            # st = ls[-2]
            if not sn.startswith("_"):
                if is_symbol_name(sn):
                    syms.append(sn)
        except Exception as e:
            print("failes to parse line", line)
            raise e
    print(f"// returning syms {syms}")
    return syms


def get_lib_source(libs: list[PluginLibrary]) -> str:

    s = ""
    s += """
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
"""
    s += "\n#define DLSYM(sym, prefix) \t\\\n    if (strcmp(symbol, #sym) == 0) { \\\n        extern void* prefix##sym; \\\n\t\tdbg_print(\"(dlsym) found symbol %s with handle=%p, address=%p\\n\", symbol, handle, &prefix##sym); \\\n        return &prefix##sym; \\\n    }\n"

    s += """
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

static const char* main_program_handle = "main_program";

"""
    for plugin in libs:
        s += plugin.extern_c_source()

    s += "\n"
    s += "void* dlopen(const char *path, int mode) {\n"
    s += "\tif (path == NULL) { return &main_program_handle; }\n"
    for plugin in libs:
        s += plugin.dlopen_c_source()

    s += '\tfprintf(stderr, "(dlopen) WARNING: failed for path %s\\n", path);'
    s += "\treturn stub_dlopen(path, mode);\n"
    s += "}\n"
    s += "\n"

    s += "void* dlsym(void *__restrict handle, const char *__restrict symbol) {\n"
    # s += "\tchar* dlsym_debug_library_name = \"?\";\n"
    for plugin in libs:
        s += plugin.dlsym_c_source()

    s += "\tconst char* dlsym_debug_library_name = \"?\";\n"
    s += "\tif (handle == NULL) { dlsym_debug_library_name = \"NULL\"; }\n"
    s += "\telse if (handle == &main_program_handle) { dlsym_debug_library_name = \"main_program_handle\"; }\n"

    for plugin in libs:
        s += plugin.dlsym_c_dbg_source()

    s += '\tfprintf(stderr, "(dlsym) WARNING: failed for symbol %s (handle=%p, path=%s)\\n", symbol, handle, dlsym_debug_library_name);'

    s += "\treturn stub_dlsym(handle, symbol);\n"
    s += "}\n"
    s += "\n"
    s += """
int dladdr(const void *handle, Dl_info *info)
{
    fprintf(stderr, "(dladdr) handle=\\\"%p\\\"\\n", handle);
    return stub_dladdr(handle, info);
}
"""
    return s


def get_libary_from_path(path: str, names: list[str], prefix: str = "", filter_rule=None) -> PluginLibrary:
    if filter_rule is None:
        def filter_rule(x): return True

    symbols = get_lib_syms(path)
    symbols_f = list(filter(filter_rule, symbols))
    library = PluginLibrary(names=names, prefix=prefix, symbols=symbols_f)
    return library


def fail_argv(s):
    raise Exception(
        f"ERROR: must be on for <path>=<name1>,<name2>,.. ,=<prefix> not: \"{s}\"")


def parse_argv(argv: list[str]) -> list[dict]:
    libs = []
    for s in argv:
        split1 = s.split("=")
        if not (len(split1) == 3):
            fail_argv(s)
        libpath = split1[0]
        names_str = split1[1]
        names = list(filter(lambda s: s != "", names_str.split(",")))
        if len(names) == 0:
            fail_argv(s)
        prefix = split1[2]

        lib_dict = {"path": libpath, "names": names, "prefix": prefix}
        libs.append(lib_dict)
    return libs


def simple_parse(argv):
    # argv = sys.argv[1:]
    if len(argv) == 0:
        raise Exception("at least one argument needed")
    libs_in = parse_argv(argv)
    plugins = []
    for l in libs_in:
        print(f"l={l}")
        path = l["path"]
        names = l["names"]
        prefix = l["prefix"]
        plugin = get_libary_from_path(path, names, prefix)
        plugins.append(plugin)
    # plugin = PluginLibrary(names=["lib.so", "lib.so.1"], symbols=[  "foo", "bar", "baz"])
    source = get_lib_source(plugins)
    print(source)


def json_parse(argv):
    import json
    libs = []
    for elem in argv:
        lib_d = json.loads(elem)
        names = lib_d["names"]
        if "prefix" in lib_d:
            prefix = lib_d["prefix"]
        else:
            prefix = ""

        if "symbols" in lib_d:
            symbols = lib_d["symbols"]

        if "path" in lib_d:
            if "symbols" in lib_d:
                raise Exception(f"Cannot have 'symbols' and 'path' ({elem})")
            path = lib_d["path"]
            plugin = get_libary_from_path(path, names, prefix)

        else:
            if not "symbols" in lib_d:
                raise Exception(f"Needs either 'symbols' or 'path' ({elem})")
            plugin = PluginLibrary(names, prefix, symbols)

        libs.append(plugin)
    s = get_lib_source(libs)
    print(s)


if __name__ == "__main__":
    import sys
    json_parse(sys.argv[1:])
