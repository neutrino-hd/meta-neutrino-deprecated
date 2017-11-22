DESCRIPTION = "udpxy is a UDP-to-HTTP multicast traffic relay daemon"
HOMEPAGE = "http://sourceforge.net/projects/udpxy"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://${THISDIR}/files/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI = " \
	git://github.com/pcherenkov/udpxy.git;protocol=https \
	file://GPL-3.0 \
	file://udpxy.service \
	file://udpxy.default \
"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git/chipmunk"

inherit autotools systemd

SYSTEMD_SERVICE_${PN} = "udpxy.service"

CFLAGS_append += "-Wno-format-truncation"

do_configure_append () {
	ln -sf ${S}/* ${WORKDIR}/build/
}

do_compile () {
	oe_runmake rdebug
}

do_install(){
	install -d ${D}/${bindir} ${D}${systemd_unitdir}/system/ ${D}${sysconfdir}/systemd/system/multi-user.target.wants/
	install -m 644 -D ${WORKDIR}/${PN}.default ${D}${sysconfdir}/default/${PN}
	install -m 755 ${WORKDIR}/build/udpxy ${D}/${bindir}/
	install -m 755 ${WORKDIR}/build/udpxrec ${D}/${bindir}/
	install -m 644 ${WORKDIR}/udpxy.service ${D}${systemd_unitdir}/system/udpxy.service
	ln -sf ${systemd_unitdir}/system/udpxy.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/udpxy.service
}

