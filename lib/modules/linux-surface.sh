#!/usr/bin/env bash

__pacman_install_retry() {
    for i in {1..5}; do
        if pacman --noconfirm -S "${@}"; then
            break
        fi

        local n=$((5 * 2**i))

        echo "failed to install ${*}, trying again in $n seconds"
        sleep $n
    done
}

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

    # WORKAROUND: This is a workaround for an issue with GitHub CI. Normally,
    # we would install these packages together with the other packages via the
    # packages/install file, however, when running in CI on GitHub, pacman
    # regularly fails to download the package files for some reason. We have
    # not yet figured out why, so as a workaround install the problematic
    # packages here. If the download/installation fails, wait for a bit and try
    # again, up to 5 times before giving up.
    __pacman_install_retry linux-firmware-msft-surface-pro-x linux-firmware-msft-surface-pro-x-qcom
    __pacman_install_retry linux-surface linux-surface-headers
}
