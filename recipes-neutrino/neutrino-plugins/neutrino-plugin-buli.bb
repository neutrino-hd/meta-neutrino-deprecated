DESCRIPTION = "Neutrino BuLi Live Ticker"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.coolstream.to/index.php?page=Thread&threadID=15040&pageNo=1"
MAINTAINER = "Tischi"
DEPENDS = "lua lua-json"

SRCREV = "${AUTOREV}"
PV = "1.7"
PR = "1"


SRC_URI = "git://github.com/Tischi81/BuliliveTicker.git \
"

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/bulilive* ${D}/var/tuxbox/plugins
}




