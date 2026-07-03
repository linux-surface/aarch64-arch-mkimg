#!/usr/bin/env bash

_qcom_wifi_fix_rmtfs_dummy_patch() {
    local pkgbuild="${_BUILDDIR}/ls/rmtfs-dummy/PKGBUILD"

    sed -i \
        -e 's#git apply "\$srcdir/0001-Redirect-file-lookups-to-var-lib-rmtfs.patch"#patch -p1 --fuzz=3 < "$srcdir/0001-Redirect-file-lookups-to-var-lib-rmtfs.patch"#' \
        -e '/git apply "\$srcdir\/0001-rmtfs-Fix-command-line-argument-parsing-for-o-optarg.patch"/d' \
        "${pkgbuild}"
}

_qcom_wifi_makepkg() {
    _msg2 "Building Qualcomm WiFi packages..."

    cd "${_BUILDDIR}" || exit 1

    _makepkg_git_clone "https://github.com/linux-surface/aarch64-packages" "ls"

    _qcom_wifi_fix_rmtfs_dummy_patch

    _makepkg_build_install "${_BUILDDIR}/ls/qmic"
    _makepkg_build_install "${_BUILDDIR}/ls/qrtr"
    _makepkg_build_install "${_BUILDDIR}/ls/tqftpserv"
    _makepkg_build_install "${_BUILDDIR}/ls/pd-mapper"
    _makepkg_build_install "${_BUILDDIR}/ls/rmtfs-dummy"

    cd /
}

_qcom_wifi_services() {
    _msg2 "Enabling Qualcomm WiFi services..."

    systemctl enable pd-mapper.service
    systemctl enable tqftpserv.service
    systemctl enable rmtfs.service
}

install() {
    _qcom_wifi_makepkg
    _qcom_wifi_services
}
