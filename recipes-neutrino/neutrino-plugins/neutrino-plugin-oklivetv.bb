DESCRIPTION = "Neutrino okLiveTV Plugin"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = ""
MAINTAINER = "Jacek Jendrzej"
DEPENDS = "lua5.2 expat"
RDEPENDS_${PN} = "lua-expat lua-feedparser lua-curl"

PV = "0.1"
PR = "1"


SRC_URI = "file://oklivetv.cfg \
	   file://oklivetv.lua \
"

S = "${WORKDIR}/"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/oklivetv.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/oklivetv.cfg ${D}/var/tuxbox/plugins
}




