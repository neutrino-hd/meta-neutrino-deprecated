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

SRC_URI[md5sum] = "412f95c9c7d23c1cbbebe3b70c0fdf1a"
SRC_URI[sha256sum] = "9f6688afffd91514c5fc54f925048f2f6b0408a3e3a9aed6fb963fc6bfa4d2f4"

