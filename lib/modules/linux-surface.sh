#!/usr/bin/env bash

setup() {
    _msg2 "Adding linux-surface repository..."

    # import GPG key 
    curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc \
        | pacman-key --add -

    pacman-key --finger 56C464BAAC421453
    pacman-key --lsign-key 56C464BAAC421453

    # add repository
    cat << EOF >> /etc/pacman.conf
[linux-surface]
Server = https://pkg.surfacelinux.com/arch-aarch64/
EOF

    # update
    pacman --noconfirm -Syu
}
