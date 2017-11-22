DESCRIPTION = "Neutrino Lua LocalTV Plugin"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = ""
MAINTAINER = "Jacek Jendrzej"
DEPENDS = "lua"

PV = "0.23"
PR = "1"

SRC_URI = "file://localtv.tar.gz \
"

S = "${WORKDIR}"

do_install () {
	install -d ${D}/etc/neutrino/plugins 
	install -m 644 ${WORKDIR}/LocalTV.lua ${D}/etc/neutrino/plugins
	install -m 644 ${WORKDIR}/LocalTV.cfg ${D}/etc/neutrino/plugins
	install -m 644 ${WORKDIR}/LocalTV_hint.png ${D}/etc/neutrino/plugins
}




