Compatible_TCLIBC = "uclibc"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://match.c_build_fix.patch"

EXTRA_OECONF +="--without-noexec"
