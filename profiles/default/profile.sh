#!/usr/bin/env bash

build() {
    _root_check
    _prepare_sources
    _rootfs_build
    _rootfs_cleanup_full
    _img_prepare_tree_default
    _img_build
}
