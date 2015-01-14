Compatible_TCLIBC = "uclibc"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://getloadavg.patch"
