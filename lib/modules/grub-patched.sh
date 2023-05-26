#!/usr/bin/env bash

install() {
    local grub_url="https://github.com/linux-surface/grub-image-aarch64/releases/download/fedora-39-1/bootaa64.efi"

    _msg2 "Installing GRUB..."

    wget "${grub_url}" -O "${_BUILDDIR}/bootaa64.efi"
    mkdir -p "/efi/EFI/Boot/"
    mv "${_BUILDDIR}/bootaa64.efi" "/efi/EFI/Boot/bootaa64.efi"
}
