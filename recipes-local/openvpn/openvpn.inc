DESCRIPTION = "A full-featured SSL VPN solution via tun device."
HOMEPAGE = "http://openvpn.sourceforge.net"
SECTION = "console/network"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
PRIORITY = "optional"

DEPENDS = "lzo openssl libpam"

SRC_URI = "http://openvpn.net/release/openvpn-${PV}.tar.gz \
	   file://openvpn"

S = "${WORKDIR}/openvpn-${PV}"

CFLAGS += "-fno-inline"

inherit autotools update-rc.d

INITSCRIPT_NAME = "openvpn"
INITSCRIPT_PARAMS = "start 60 S . stop 20 0 1 2 3 4 6 ."

do_install_append() {
	install -d ${D}/${sysconfdir}/init.d
	install -d ${D}/${sysconfdir}/openvpn
	install -m 755 ${WORKDIR}/openvpn ${D}/${sysconfdir}/init.d
}

FILES_${PN}-dbg += "/usr/lib/openvpn/plugins/.debug"
