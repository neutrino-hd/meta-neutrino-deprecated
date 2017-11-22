DESCRIPTION = "udpxy is a UDP-to-HTTP multicast traffic relay daemon"
HOMEPAGE = "http://sourceforge.net/projects/udpxy"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${THISDIR}/files/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = " \
	git://github.com/pcherenkov/udpxy.git;protocol=https \
	file://GPL-3.0 \
	file://udpxy.init \
	file://udpxy.default \
"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git/chipmunk"

inherit autotools update-rc.d

INITSCRIPT_NAME = "udpxy"
INITSCRIPT_PARAMS = "defaults"

CFLAGS_append += "-Wno-format-truncation"

do_configure_append () {
	ln -sf ${S}/* ${WORKDIR}/build/
}

do_compile () {
	oe_runmake rdebug
}

do_install(){
	install -d ${D}/${bindir}
	install -m 755 -D ${WORKDIR}/${PN}.init ${D}${sysconfdir}/init.d/${PN}
	install -m 644 -D ${WORKDIR}/${PN}.default ${D}${sysconfdir}/default/${PN}
	install -m 755 ${WORKDIR}/build/udpxy ${D}/${bindir}/
	install -m 755 ${WORKDIR}/build/udpxrec ${D}/${bindir}/
}

