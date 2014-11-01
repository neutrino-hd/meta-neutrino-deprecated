Compatible_TCLIBC = "uclibc"

FILESEXTRAPATHS_prepend := "${THISDIR}/kmod:"

SRC_URI += "file://0001-libkmod-internal.h-uclibc-comes-without-secure_geten.patch"
