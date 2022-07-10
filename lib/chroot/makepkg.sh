#!/usr/bin/env bash

_BUILDUSER="builduser"
_BUILDDIR="/home/${_BUILDUSER}"

_makepkg_setup() {
    _msg1 "Setting up temporary build user.."
    useradd -m "${_BUILDUSER}"
}

_makepkg_cleanup() {
    _msg1 "Removing temporary build user..."
    userdel --remove "${_BUILDUSER}" > /dev/null 2>&1
}

_makepkg_build_install() {
    local dir="${1}"
    local exitcode=0

    _pushd "${dir}"

    su "${_BUILDUSER}" -c makepkg || exitcode=$?
    if [[ $exitcode -ne 0 ]]; then
        _popd
        return $exitcode
    fi

    _pacman_install_local ./*.pkg.tar.*
    _popd
}

_makepkg_run_as_builduser() {
    su "${_BUILDUSER}" -c "${@}"
}

_makepkg_git_clone() {
    _makepkg_run_as_builduser "git clone '${1}' '${2}'"
}
