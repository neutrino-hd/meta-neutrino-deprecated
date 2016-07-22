DESCRIPTION = "Add Rockpalast"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
MAINTAINER = "bazi98"
HOMEPAGE = "http://www.dbox2world.net/board293-cst-coolstream/board313-cst-coolstream-downloads/board319-coolstream-plugins/12751-wdr-rockpalast/"

S = "${WORKDIR}"

PR = "r1"

SRC_URI = "file://rockpalast.cfg \
	   file://rockpalast.lua \
	   file://rockpalast_hint.png \
	   file://license \
"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/rockpalast.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/rockpalast.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/rockpalast_hint.png ${D}/var/tuxbox/plugins
}
