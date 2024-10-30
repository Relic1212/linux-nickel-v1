# FROM 
FROM docker.io/library/alpine:edge

RUN apk upgrade

# RUN apk add gcc make linux-headers alpine-sdk ncurses-dev flex bison ccache python3
RUN apk add clang lld  clang19-ccache python3 cmake ccache
RUN apk add shadow py3-pip nickel bubblewrap make rsync flex bison
RUN apk add llvm-libunwind-dev  libc++ libc++-dev  compiler-rt llvm-libunwind-static patch  llvm-dev


# RUN apk add libelf
# RUN apk add elfutils-dev
# RUN apk add openssl
# RUN apk add openssl-dev
# RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing fscrypt
# RUN apk add ncurses-dev ncurses-libs ncurses-static ncurses-terminfo
# RUN apk add diffutils findutils perl ripgrep erofs-utils  f2fs-tools
# RUN apk add linux-pam meson ninja cmake go rsync curl
 # RUN apk add zsh shadow alpine-zsh-config zsh-autosuggestions
# RUN apk add python3 py3-pip py3-pip-tools jupyter-notebook
# RUN apk add cairo-dev \
#    eudev-dev \
#    gdk-pixbuf-dev \
#    json-c-dev \
#    libdisplay-info-dev \
#    libevdev-dev \
#    libinput-dev \
#    libseat-dev \
#    libxcb-dev \
#    libxkbcommon-dev \
#    mesa-dev \
#    meson \
#    pango-dev \
#    pcre2-dev \
#    pixman-dev \
#    scdoc \
#    wayland-dev \
#    wayland-protocols \
#    xcb-util-image-dev \
#    xcb-util-wm-dev \
#    xwayland-dev \
#    hwdata-dev
# RUN chsh -s /bin/zsh root
RUN adduser -D -s /bin/sh   user 

RUN apk add doas
# RUN apk add bubblewrap rsync
# RUN apk add xz
RUN usermod -a -G wheel user
RUN echo permit nopass :wheel >> /etc/doas.conf
RUN echo permit nopass :user >> /etc/doas.conf

#RUN pip3 install --user oelint-adv
