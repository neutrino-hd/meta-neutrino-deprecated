include nano.inc

PR = "${INC_PR}.0"

SRC_URI += "file://ncursesw.includedir.patch \
	    file://*.nanorc \
	    file://nanorc \
"

SRC_URI[md5sum] = "03233ae480689a008eb98feb1b599807"
SRC_URI[sha256sum] = "be68e133b5e81df41873d32c517b3e5950770c00fc5f4dd23810cd635abce67a"

do_install(){
	install -d ${D}/${datadir}/nano ${D}/${sysconfdir} ${D}/${bindir}
	install -m 644 ${WORKDIR}/*.nanorc ${D}${datadir}/nano/
	install -m 644 ${WORKDIR}/nanorc ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/build/src/nano ${D}${bindir}/
}
