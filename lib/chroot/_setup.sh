#!/usr/bin/env bash
set -e

_CHROOT_BASE="/root/aarch64-archimg"
_CHROOT_LIB="${_CHROOT_BASE}/lib"
_CHROOT_MODULES="${_CHROOT_BASE}/modules"
_CHROOT_PACKAGES="${_CHROOT_BASE}/packages"

source "${_CHROOT_LIB}/base.sh"
source "${_CHROOT_LIB}/log.sh"
source "${_CHROOT_LIB}/makepkg.sh"
source "${_CHROOT_LIB}/modules.sh"
source "${_CHROOT_LIB}/pacman.sh"

_pacman_setup
_pacman_uninstall
_pacman_update
_modules_setup
_pacman_install
_makepkg_setup
_modules_install
_makepkg_cleanup
