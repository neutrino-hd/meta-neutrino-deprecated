Compatible_TCLIBC = "uclibc"

FILESEXTRAPATHS_prepend := "${THISDIR}/nfs-utils:"

SRC_URI += "file://sockaddr_h.patch"
