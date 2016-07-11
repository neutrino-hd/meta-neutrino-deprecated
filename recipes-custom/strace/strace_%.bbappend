FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_libc-uclibc += "file://fix.patch"
