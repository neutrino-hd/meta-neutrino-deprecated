Compatible_TCLIBC = "uclibc"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
RDEPENDS_${PN}_coolstream-hd2 = " ${@bb.utils.contains('DISTRO_FEATURES', 'pam', 'pam-plugin-limits pam-plugin-keyinit', '', d)} libiconv gettext-runtime"

SRC_URI += "file://match.c_build_fix.patch"

EXTRA_OECONF +="--without-noexec"
