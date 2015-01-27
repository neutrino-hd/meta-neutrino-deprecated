FILESEXTRAPATHS_prepend := "${THISDIR}/nfs-utils:"

SRC_URI_append_libc-uclibc += "file://sockaddr_h.patch"
