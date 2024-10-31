
FROM  library/archlinux:latest 

RUN pacman -Syu --noconfirm
# RUN pacman -S --noconfirm doas base-devel rsync bubblewrap ccache cmake python3 nickel
RUN pacman -S --noconfirm doas  rsync bubblewrap python3 

RUN useradd -m -s /bin/sh   user 

RUN usermod -a -G wheel user
RUN echo permit nopass :wheel >> /etc/doas.conf
RUN echo permit nopass :user >> /etc/doas.conf