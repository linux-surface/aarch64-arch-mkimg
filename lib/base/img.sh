#!/usr/bin/env bash

_img_prepare_tree_default() {
    _msg1 "Preparing disk image tree..."
    rm -rf "${_DIR_DISK}"

    _msg2 "Preparing EFI partition..."
    mkdir -p  "${_DIR_DISK_EFI}"
    cp -a "${_DIR_BUILD_ROOTFS}/efi/." "${_DIR_DISK_EFI}"

    _msg2 "Preparing root partition..."
    mkdir -p  "${_DIR_DISK_ROOT}"
    cp -a "${_DIR_BUILD_ROOTFS}/." "${_DIR_DISK_ROOT}"
    rm -rf "${_DIR_DISK_ROOT}/efi"
}

_img_prepare_tree_ramfs() {
    _msg1 "Preparing disk image tree..."
    rm -rf "${_DIR_DISK}"

    _msg2 "Preparing EFI partition..."
    mkdir -p  "${_DIR_DISK_EFI}"
    cp -a "${_DIR_BUILD_ROOTFS}/efi/." "${_DIR_DISK_EFI}"

    _msg2 "Preparing root partition..."
    mkdir -p  "${_DIR_DISK_ROOT}/boot"
    cp -a "${_DIR_BUILD_ROOTFS}/boot/." "${_DIR_DISK_ROOT}/boot"
    rm -f "${_DIR_DISK_ROOT}/boot"/*.img

    local initram="${_DIR_DISK_ROOT}/boot/initramfs-full.img"

    _msg2 "Preparing full initram..."

    local tmpdir;
    tmpdir=$(mktemp -d -t aarch64-archiso-rootfs-XXXXXXXXXX)

    cp -a "${_DIR_BUILD_ROOTFS}/." "${tmpdir}"

    _pushd "${tmpdir}"
    ln -s sbin/init init
    rm -rf "./efi"
    find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > "${initram}"
    _popd

    rm -rf "${tmpdir}"
}
