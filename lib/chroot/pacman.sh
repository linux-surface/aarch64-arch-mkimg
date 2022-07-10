#!/usr/bin/env bash

_pacman_setup() {
    _msg1 "Setting up pacman key database..."
    pacman-key --init
    pacman-key --populate archlinuxarm
}

_pacman_update() {
    _msg1 "Updating the system..."
    pacman --noconfirm -Syu
}

_pacman_install() {
    _msg1 "Installing requested packages..."
    if [[ -f "${_CHROOT_PACKAGES}/install" ]]; then
        local pkglist
        mapfile -t pkglist < "${_CHROOT_PACKAGES}/install"

        if [[ ${#pkglist[@]} -gt 0 ]]; then
            pacman --noconfirm -S "${pkglist[@]}"
        fi
    fi

    _msg1 "Installing custom packages..."
    if [[ -d "${_CHROOT_PACKAGES}/custom" ]]; then
        shopt -s nullglob
        pkglist=("${_CHROOT_PACKAGES}/custom"/*.pkg.tar{,.xz,.zst})
        shopt -u nullglob

        if [[ ${#pkglist[@]} -gt 0 ]]; then
            pacman --noconfirm -U "${pkglist[@]}"
        fi
    fi
}

_pacman_uninstall() {
    _msg1 "Uninstalling requested packages..."
    if [[ -f "${_CHROOT_PACKAGES}/uninstall" ]]; then
        local pkglist
        mapfile -t pkglist < "${_CHROOT_PACKAGES}/uninstall"

        if [[ ${#pkglist[@]} -gt 0 ]]; then
            pacman --noconfirm -Rns "${pkglist[@]}"
        fi
    fi
}

_pacman_install_local() {
    pacman --noconfirm -U "${@}"
}
