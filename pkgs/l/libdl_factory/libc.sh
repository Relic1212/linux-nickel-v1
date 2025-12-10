cp /usr/lib/libc.a .
objcopy --redefine-sym=dlopen=dlopen_libc libc.a
objcopy --redefine-sym=dlsym=dlsym_libc libc.a
objcopy --redefine-sym=dladdr=dladdr_libc libc.a
objcopy --globalize-symbol stub_dlopen libc.a
objcopy --globalize-symbol stub_dlsym libc.a
objcopy --globalize-symbol stub_dladdr libc.a
ar r libc.a out/dl_factory.c.o 