#!/usr/bin/env bash

_qcom_wifi_makepkg() {
    _msg2 "Building Qualcomm WiFi packages..."

    cd "${_BUILDDIR}" || exit 1

    _makepkg_git_clone "https://github.com/andersson/arch-packages" "andersson"
    _makepkg_git_clone "https://github.com/linux-surface/aarch64-packages" "ls"

    _makepkg_build_install "${_BUILDDIR}/andersson/qmic-pkg"
    _makepkg_build_install "${_BUILDDIR}/andersson/qrtr-pkg"
    _makepkg_build_install "${_BUILDDIR}/andersson/tqftpserver-pkg"
    _makepkg_build_install "${_BUILDDIR}/andersson/pd-mapper-pkg"
    _makepkg_build_install "${_BUILDDIR}/ls/rmtfs-dummy"

    cd /
}

_qcom_wifi_services() {
    _msg2 "Enabling Qualcomm WiFi services..."

    systemctl enable qrtr-ns.service
    systemctl enable pd-mapper.service
    systemctl enable tqftpserv.service
    systemctl enable rmtfs.service
}

install() {
    _qcom_wifi_makepkg
    _qcom_wifi_services
}
