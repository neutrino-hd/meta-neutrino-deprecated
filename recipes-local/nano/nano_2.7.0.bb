include nano.inc

PR = "1"

SRC_URI += "file://*.nanorc \
	    file://nanorc \
"

inherit pkgconfig

SRC_URI[md5sum] = "0805c5b8c75d4fde053e4b1431270f91"
SRC_URI[sha256sum] = "5dd1e9cf8e3de676c141a0b23f312e68380ef049926e2913e2114bbe32fbeac3"

do_install(){
	install -d ${D}/${datadir}/nano ${D}/${sysconfdir} ${D}/${bindir}
	install -m 644 ${WORKDIR}/*.nanorc ${D}${datadir}/nano/
	install -m 644 ${WORKDIR}/nanorc ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/build/src/nano ${D}${bindir}/
}

