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

SRC_URI[md5sum] = "8af1dbf05e8bfdf0ad0479240a39b2bb"
SRC_URI[sha256sum] = "071a01c4b8ba2c7a0b24fa77502ca905bc63781c8f69856191e5c14895bce548"

