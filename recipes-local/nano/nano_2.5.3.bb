include nano.inc

PR = "1"

SRC_URI += "file://*.nanorc \
	    file://nanorc \
"

inherit pkgconfig

SRC_URI[md5sum] = "a04d77611422ab4b6a7b489650c7a793"
SRC_URI[sha256sum] = "b2b060129b9feff2d4870d803a441178c96531de9aed144ec0b83bd63ccb12ee"

do_install(){
	install -d ${D}/${datadir}/nano ${D}/${sysconfdir} ${D}/${bindir}
	install -m 644 ${WORKDIR}/*.nanorc ${D}${datadir}/nano/
	install -m 644 ${WORKDIR}/nanorc ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/build/src/nano ${D}${bindir}/
}

