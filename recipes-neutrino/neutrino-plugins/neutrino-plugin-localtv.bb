DESCRIPTION = "Neutrino Lua LocalTV Plugin"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = ""
MAINTAINER = "Jacek Jendrzej"
DEPENDS = "lua5.2"

PV = "0.14"
PR = "1"

SRC_URI = "file://LocalTV.cfg \
	   file://LocalTV.lua \
"

S = "${WORKDIR}/"

do_install () {
	install -d ${D}/var/tuxbox/plugins 
	install -m 644 ${S}/LocalTV.lua ${D}/var/tuxbox/plugins
	if [ ${USE_VAR} == "yes" ];then
		install -d ${D}/var/tuxbox/config
		install -m 644 ${S}/LocalTV.cfg ${D}/var/tuxbox/config
	else
		install -d ${D}/etc/neutrino/config
		install -m 644 ${S}/LocalTV.cfg ${D}/etc/neutrino/config
	fi
}




