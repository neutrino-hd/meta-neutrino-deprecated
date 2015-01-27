FILESEXTRAPATHS_prepend := "${THISDIR}/kmod:"

SRC_URI_append_libc-uclibc += "file://0001-libkmod-internal.h-uclibc-comes-without-secure_geten.patch"
