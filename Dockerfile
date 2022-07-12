FROM archlinux/archlinux

RUN pacman --noconfirm -Syu \
    && pacman --noconfirm -S wget libarchive arch-install-scripts \
                             cpio gdisk dosfstools e2fsprogs

RUN mkdir -p /var/aarch64-arch-mkimg/
COPY lib /var/aarch64-arch-mkimg/lib/
COPY profiles /var/aarch64-arch-mkimg/profiles/
COPY aarch64-arch-mkimg /var/aarch64-arch-mkimg/

ENTRYPOINT ["/var/aarch64-arch-mkimg/aarch64-arch-mkimg"]
