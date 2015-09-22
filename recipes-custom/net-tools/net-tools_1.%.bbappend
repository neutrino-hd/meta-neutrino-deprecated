FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_libc-uclibc += "file://net-tools-config.h"
