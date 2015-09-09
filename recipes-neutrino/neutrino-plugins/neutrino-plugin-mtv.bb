DESCRIPTION = "MTV Lua Plugin"
LICENSE = "GPL-2.0"
MAINTAINER = "Jacek Jendrzej"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.dbox2world.net/board293-cst-coolstream/board313-cst-coolstream-downloads/board319-coolstream-plugins/12579-mtv-de-video-plugin-version-0-1/"

RDEPENDS_${PN} += "rtmpdump"

S = "${WORKDIR}"

PR = "r1"

SRC_URI = "file://mtv.lua \
	   file://mtv.cfg \
	   file://mtv_hint.png \
"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/mtv.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/mtv.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/mtv_hint.png ${D}/var/tuxbox/plugins
	
}

