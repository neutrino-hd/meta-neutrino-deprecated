DESCRIPTION = "ni Logos"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://www.neutrino-images.de/board/viewtopic.php?f=40&t=54"

S = "${WORKDIR}/ng_logobasis300"

PR = "r2"

SRC_URI = "http://www.neutrino-images.de/channellogos/ni_logobasis.zip \
	   file://license \
"
do_install() {
    install -d ${D}/usr/share/tuxbox/neutrino/icons/logo
    install -m 0644 ${S}/* ${D}/usr/share/tuxbox/neutrino/icons/logo/
}

FILES_${PN} = "\
    /usr/share/tuxbox/neutrino/icons/logo \
"

SRC_URI[md5sum] = "124b860525a685bc886b0476e1f1f3b3"
SRC_URI[sha256sum] = "4136219c770eae2b72bae4df8df22004454a22cd55082b62a6cc6c4112548be5"


