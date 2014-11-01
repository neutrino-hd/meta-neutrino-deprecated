COMPATIBLE_MACHINE = "coolstream-hd2"
FILESEXTRAPATHS_prepend := "${THISDIR}/uclibc:"

SRC_URI += " \
	file://uClibc.machine \
	file://uClibc.distro \
"

EXTRA_OECONF = "--hash-style=gnu"
