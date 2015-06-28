DESCRIPTION = "Neutrino BuLi Live Ticker"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.coolstream.to/index.php?page=Thread&threadID=15040&pageNo=1"
MAINTAINER = "Tischi"
DEPENDS = "lua5.2 lua-json"

SRCREV = "1.3"
PR = "1"


SRC_URI = "file://buliliveticker.cfg \
	   file://buliliveticker.lua \
	   file://buliliveticker.png \
	   file://buliliveicon.png \
"

S = "${WORKDIR}/"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/bulilive* ${D}/var/tuxbox/plugins
}




