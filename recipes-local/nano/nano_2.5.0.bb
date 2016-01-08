include nano.inc

PR = "1"

SRC_URI += "file://*.nanorc \
	    file://nanorc \
"

inherit pkgconfig

SRC_URI[md5sum] = "751ed96457017572bab15be18cb873ba"
SRC_URI[sha256sum] = "ff323e6fef74caf0a924304841c07ac65ec30db99dc5c1f8272b4c536a5c89ee"

do_install(){
	install -d ${D}/${datadir}/nano ${D}/${sysconfdir} ${D}/${bindir}
	install -m 644 ${WORKDIR}/*.nanorc ${D}${datadir}/nano/
	install -m 644 ${WORKDIR}/nanorc ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/build/src/nano ${D}${bindir}/
}

