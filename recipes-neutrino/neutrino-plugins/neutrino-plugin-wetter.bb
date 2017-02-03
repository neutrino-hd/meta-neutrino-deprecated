DESCRIPTION = "Neutrino Wetter App"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.coolstream.to/index.php?page=Thread&threadID=15384&pageNo=16"
MAINTAINER = "Tischi"
DEPENDS = "lua lua-json"

SRC_URI = "file://luawetterapp.cfg \
	   file://luawetterapp.lua \
	   file://luawettericon.png \
"

PV = "1.4"
PR = "1"

S = "${WORKDIR}"

do_install () {
	install -d ${D}/var/tuxbox/plugins 
	install -m 644 ${S}/luawetterapp.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/luawetterapp.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/luawettericon.png ${D}/var/tuxbox/plugins
}




