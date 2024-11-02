export CCACHE_DIR=$(realpath ./build/ccache)
# export CCACHE_CONFIGPATH=/data/user/busybox-linux/build/ccache
CCACHE_MAXSIZE=0
#export CC="ccache clang"
export PATH="/usr/lib/ccache/bin:${PATH}"
