DESCRIPTION = "Neutrino Lua LocalTV Plugin"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = ""
MAINTAINER = "Jacek Jendrzej"
DEPENDS = "lua"

PV = "0.23"
PR = "1"

SRC_URI = "file://LocalTV.cfg \
	   file://LocalTV.lua \
	   file://LocalTV_hint.png \
"

S = "${WORKDIR}/"

do_install () {
	install -d ${D}/var/tuxbox/plugins 
	install -m 644 ${S}/LocalTV.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/LocalTV.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/LocalTV_hint.png ${D}/var/tuxbox/plugins

}




