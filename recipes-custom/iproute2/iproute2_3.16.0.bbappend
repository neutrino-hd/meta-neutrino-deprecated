Compatible_TCLIBC = "uclibc"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://ipnetns.patch"
