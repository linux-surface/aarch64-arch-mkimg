#!/usr/bin/env bash

_CHROOT_BASE="/root/aarch64-archimg"
_CHROOT_LIB="${_CHROOT_BASE}/lib"
_CHROOT_SETUP="${_CHROOT_LIB}/_setup.sh"
_CHROOT_MODULES="${_CHROOT_BASE}/modules"
_CHROOT_PACKAGES="${_CHROOT_BASE}/packages"


_rootfs_copy_profile() {
    _msg2 "Copying base files..."

    if [[ -d "${_PROFILE_DIR}/base" ]]; then
        cp -r "${_PROFILE_DIR}/base/." "${_DIR_BUILD_ROOTFS}"
    fi
}

_rootfs_chroot_install() {
    _msg2 "Installing chroot scripts..."

    mkdir -p "${_DIR_BUILD_ROOTFS:?}/${_CHROOT_BASE}"

    cp -rL "${_DIR_BASE}/lib/chroot/." "${_DIR_BUILD_ROOTFS:?}/${_CHROOT_LIB}"
    cp -rL "${_PROFILE_DIR}/modules/." "${_DIR_BUILD_ROOTFS:?}/${_CHROOT_MODULES}"
    cp -rL "${_PROFILE_DIR}/packages/." "${_DIR_BUILD_ROOTFS:?}/${_CHROOT_PACKAGES}"

    chmod +x "${_DIR_BUILD_ROOTFS:?}/${_CHROOT_SETUP}"
}

_rootfs_chroot_cleanup() {
    _msg2 "Cleaning up..."
    rm -rf "${_DIR_BUILD_ROOTFS:?}/${_CHROOT_BASE}"
}

_rootfs_chroot_run() {
    _msg2 "Switching into rootfs..."

    mount --bind "${_DIR_BUILD_ROOTFS}" "${_DIR_BUILD_ROOTFS}"

    local exit_code=0
    arch-chroot "${_DIR_BUILD_ROOTFS}" "${_CHROOT_SETUP}" || exit_code=$?

    # delay unmounting to prevent "is busy" errors
    sleep 1.0
    umount -R "${_DIR_BUILD_ROOTFS}"

    return ${exit_code}
}

_rootfs_build() {
    _msg1 "Preparing rootfs..."
    _rootfs_copy_profile
    _rootfs_chroot_install
    _rootfs_chroot_run
    _rootfs_chroot_cleanup
}


_rootfs_cleanup_tmp() {
    _msg2 "Removing temporary files..."
    rm -rf "${_DIR_BUILD_ROOTFS:?}/tmp"/*
    rm -rf "${_DIR_BUILD_ROOTFS:?}/var/tmp"/*
}

_rootfs_cleanup_pacman_cache() {
    _msg2 "Removing pacman cache..."
    rm -rf "${_DIR_BUILD_ROOTFS:?}/var/cache/pacman/pkg"/*
}

_rootfs_cleanup_full() {
    _msg1 "Cleaning up rootfs..."
    _rootfs_cleanup_tmp
    _rootfs_cleanup_pacman_cache
}
