DESCRIPTION = "Neutrino Wetter App"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.coolstream.to/index.php?page=Thread&threadID=15384&pageNo=16"
MAINTAINER = "Tischi"
DEPENDS = "lua5.2 lua-json"

SRCREV = "${AUTOREV}"
PV = "1.2"
PR = "1"


SRC_URI = "git://github.com/Tischi81/LuaWetterApp.git \
"

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/luawetter* ${D}/var/tuxbox/plugins
}




