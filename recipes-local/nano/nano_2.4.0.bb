include nano.inc

PR = "1"

SRC_URI += "file://*.nanorc \
	    file://nanorc \
"

inherit pkgconfig

SRC_URI[md5sum] = "e5c9c6424ee2303663ae4b99ecd4b493"
SRC_URI[sha256sum] = "5076fb502680503e648cbdcbf2077e39fba193420ae19203f0a54cb2d94a75bd"

do_install(){
	install -d ${D}/${datadir}/nano ${D}/${sysconfdir} ${D}/${bindir}
	install -m 644 ${WORKDIR}/*.nanorc ${D}${datadir}/nano/
	install -m 644 ${WORKDIR}/nanorc ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/build/src/nano ${D}${bindir}/
}

