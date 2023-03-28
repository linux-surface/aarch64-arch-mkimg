#!/usr/bin/env bash
set -x

_ROOTFS_ARCHIVE="ArchLinuxARM-aarch64-latest.tar.gz"
_ROOTFS_URL="http://os.archlinuxarm.org/os/${_ROOTFS_ARCHIVE}"
_ALARM_GPG_KEY="68B3537F39A313B3E574D06777193F152BDBE6A6"

_prepare_source_directories() {
    mkdir -p "${_DIR_BUILD_SRC}"
}

_get_gpg_keys() {
    gpg --keyserver keyserver.ubuntu.com --recv-keys "${_ALARM_GPG_KEY}" > /dev/null  2>&1
}

_download() {
    local url="${1}"
    local target="${2}"

    wget --continue "${url}" -O "${target}" > /dev/null 2>&1
}

_verify() {
    # MD5 check
    if ! md5sum --check "${_ROOTFS_ARCHIVE}.md5" > /dev/null; then
        _log_error "MD5 verification failed for '${_ROOTFS_ARCHIVE}'"
        return 1
    fi

    # signature check
    if ! gpg --verify "${_ROOTFS_ARCHIVE}.sig" > /dev/null  2>&1; then
        _log_error "signature verification failed for '${_ROOTFS_ARCHIVE}'"
        return 1
    fi
}

_extract() {
    rm -rf "${_DIR_BUILD_ROOTFS}"
    mkdir -p "${_DIR_BUILD_ROOTFS}"
    bsdtar -xf "${_ROOTFS_ARCHIVE}" -C "${_DIR_BUILD_ROOTFS}"
}

_prepare_sources() {
    _msg1 "Preparing sources..."
    _prepare_source_directories

    _pushd "${_DIR_BUILD_SRC}" || return 1

    _msg2 "Importing Arch Linux ARM GPG key..."
    _get_gpg_keys

    _msg2 "Downloading '${_ROOTFS_ARCHIVE}'..."
    _download "${_ROOTFS_URL}" "${_ROOTFS_ARCHIVE}"
    _download "${_ROOTFS_URL}.md5" "${_ROOTFS_ARCHIVE}.md5"
    _download "${_ROOTFS_URL}.sig" "${_ROOTFS_ARCHIVE}.sig"

    _msg2 "Verifying '${_ROOTFS_ARCHIVE}'..."
    _verify || return 1
    _msg2 "Verification passed"

    _msg2 "Extracting '${_ROOTFS_ARCHIVE}'..."
    _extract

    _popd || return 1
}
