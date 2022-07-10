#!/usr/bin/env bash

install() {
    local edk2_pkg_url="https://archlinux.org/packages/extra/any/edk2-shell/download"

    _msg2 "Installing EFI shell..."

    wget "${edk2_pkg_url}" -O "${_BUILDDIR}/edk2-shell-latest.pkg.tar.zst"
    _pacman_install_local "${_BUILDDIR}/edk2-shell-latest.pkg.tar.zst"
    rm "${_BUILDDIR}/edk2-shell-latest.pkg.tar.zst"

    mkdir -p "/efi/EFI/Tools/"
    cp "/usr/share/edk2-shell/aarch64/Shell.efi" "/efi/EFI/Tools/shellaa64.efi"
}
