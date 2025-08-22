FROM docker.io/library/alpine

RUN echo 'https://ftp.acc.umu.se/mirror/alpinelinux.org/edge/main' > /etc/apk/repositories
RUN echo 'https://ftp.acc.umu.se/mirror/alpinelinux.org/edge/community' >> /etc/apk/repositories 
RUN echo 'https://ftp.acc.umu.se/mirror/alpinelinux.org/edge/testing' >> /etc/apk/repositories
RUN apk update
RUN apk upgrade

RUN apk add gcc make linux-headers alpine-sdk ncurses-dev flex bison
RUN apk add libelf
RUN apk add elfutils-dev
RUN apk add openssl
RUN apk add openssl-dev
RUN apk add diffutils findutils perl
RUN apk add llvm-dev clang-dev lld
RUN apk add lz4
RUN apk add cmake meson 
RUN apk add vim

RUN apk add rust rust-analyzer cargo

RUN apk add fish doas shadow

RUN apk add llvm-libunwind-static llvm-runtimes llvm-dev llvm llvm-static clang19 clang-static clang-dev

RUN adduser -HD user 
RUN usermod  -u 1000  -s /bin/fish -a -G wheel,tty,dialout,audio,video,kvm,input,tape user

RUN passwd -d user

