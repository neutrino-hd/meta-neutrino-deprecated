DESCRIPTION = "xupnpd - eXtensible UPnP agent"
HOMEPAGE = "http://xupnpd.org"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=193ff0a3bc8b0d2cb0d1d881586d3388"

DEPENDS += "lua"
SRCREV = "${AUTOREV}"
SRC_URI = "\
	git://github.com/clark15b/xupnpd.git;branch=master \
	file://0002-ui_restart-fix-xupnpd-install-path.patch \
	file://xupnpd.service \
	file://xupnpd.timer \
	file://xupnpd-dont-bind-daemon-to-specific-ip-address.patch \
	file://xupnpd_cst.diff \
	file://xupnpd-fix-memleak-on-coolstream-boxes.patch \
"

PV = "${SRCPV}"
PR = "1"
S = "${WORKDIR}/git/src"

inherit base systemd

SYSTEMD_SERVICE_${PN} = "xupnpd.service xupnpd.timer"

# this is very ugly, but the xupnpd makefile is utter crap :-(
SRC = "main.cpp soap.cpp mem.cpp mcast.cpp luaxlib.cpp luaxcore.cpp luajson.cpp luajson_parser.cpp"

do_compile () {
	${CC} -O2 -c -o md5.o md5c.c
	${CC} ${CFLAGS} ${LDFLAGS} -DWITH_URANDOM -o xupnpd ${SRC} md5.o -llua -lm -ldl -lstdc++ -rdynamic
}


do_install () {
	install -d -m 0644 ${D}/usr/share/xupnpd/config ${D}/usr/share/xupnpd/playlists ${D}${systemd_unitdir}/system ${D}${sysconfdir}/systemd/system/multi-user.target.wants/ ${D}${sysconfdir}/systemd/system/timers.target.wants/
	install -m 644 ${WORKDIR}/xupnpd.service ${D}${systemd_unitdir}/system/xupnpd.service
	install -m 644 ${WORKDIR}/xupnpd.timer ${D}${systemd_unitdir}/system/xupnpd.timer
	ln -sf ${systemd_unitdir}/system/xupnpd.service ${D}${sysconfdir}/systemd/system/multi-user.target.wants/xupnpd.service
	ln -sf ${systemd_unitdir}/system/xupnpd.timer ${D}${sysconfdir}/systemd/system/timers.target.wants/xupnpd.timer
	install -D -m 0755 ${S}/xupnpd ${D}${bindir}/xupnpd
	cp -r ${S}/profiles	${D}/usr/share/xupnpd/
	cp -r ${S}/ui		${D}/usr/share/xupnpd/
	cp -r ${S}/www		${D}/usr/share/xupnpd/
	cp ${S}/*.lua		${D}/usr/share/xupnpd/
}
