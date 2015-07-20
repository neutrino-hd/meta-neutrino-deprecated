DESCRIPTION = "coolstream.to Senderlogos"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://coolstream.to/"

S = "${WORKDIR}"

PR = "r1"

SRC_URI = "http://www.coolstream.to/coolstream.to/logos/Logos.zip \
	   file://license \
"
do_install_append() {
    install -d ${D}/media/sda1/logos
    install -m 0644 ${WORKDIR}/*.png ${D}/media/sda1/logos/
}

FILES_${PN} = "\
    /media/sda1/logos \
"

SRC_URI[md5sum] = "109ea93e0624b939dc148e65e93724a1"
SRC_URI[sha256sum] = "1d135c3139195e86c831aef655d67a8eee81f32ce372a30f11c0e146ebff8a1f"

