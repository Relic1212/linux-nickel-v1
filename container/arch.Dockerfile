
# FROM  library/archlinux:latest 
FROM docker.io/archlinux:latest

RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm doas rsync bubblewrap python3 gcc make patch wget

RUN useradd -m -s /bin/sh   user 

RUN usermod -a -G wheel user
RUN echo permit nopass :wheel >> /etc/doas.conf
RUN echo permit nopass :user >> /etc/doas.conf

RUN wget https://github.com/tweag/nickel/releases/download/1.16.0/nickel-x86_64-linux -O /usr/bin/nickel

RUN chmod +x  /usr/bin/nickel

