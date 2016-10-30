DESCRIPTION = "ni Logos"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://www.neutrino-images.de/board/viewtopic.php?f=40&t=54"

S = "${WORKDIR}/logo-Basis"

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

SRC_URI[md5sum] = "c0b8c0d2fa9589da2866b4d029575191"
SRC_URI[sha256sum] = "cccc3477606a098ced827416841fd48d5c94f96a4656ba0c8d338a43a209f6d1"




