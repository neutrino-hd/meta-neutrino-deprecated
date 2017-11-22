DESCRIPTION = "ni Logos"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://www.neutrino-images.de/board/viewtopic.php?f=40&t=54"

S = "${WORKDIR}/git/logos"

SRCREV = "${AUTOREV}"

PR = "r3"

SRC_URI = "git://bitbucket.org/neutrino-images/ni-logo-stuff;protocol=https \
	   file://license \
"
do_install() {
    install -d ${D}/usr/share/tuxbox/neutrino/icons/logo
    install -m 0644 ${S}/* ${D}/usr/share/tuxbox/neutrino/icons/logo/
}

FILES_${PN} = "\
    /usr/share/tuxbox/neutrino/icons/logo \
"




