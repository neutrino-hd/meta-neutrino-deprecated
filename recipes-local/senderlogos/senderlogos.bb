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

SRC_URI[md5sum] = "f12e653d11359d266e4aee56044fd5e5"
SRC_URI[sha256sum] = "db767eba1def0ec9daa478f1787fd05a8a3ff221dd886f8cd8bcfe4c0510ee19"

