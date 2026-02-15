clang -c -g -O2 -fPIC -fvisibility=hidden -fomit-frame-pointer -Wall api.c
clang -c -g -O2 -fPIC -fvisibility=hidden -fomit-frame-pointer -Wall decode.c
clang -c -g -O2 -fPIC -fvisibility=hidden -fomit-frame-pointer -Wall mem.c
clang -c -g -O2 -fPIC -fvisibility=hidden -fomit-frame-pointer -Wall ops.c
clang -c -g -O2 -fPIC -fvisibility=hidden -fomit-frame-pointer -Wall ops2.c
clang -c -g -O2 -fPIC -fvisibility=hidden -fomit-frame-pointer -Wall prim_ops.c
llvm-ar rcs libx86emu.a api.o decode.o mem.o ops.o ops2.o prim_ops.o
llvm-ranlib libx86emu.a