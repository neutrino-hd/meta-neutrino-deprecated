DESCRIPTION = "Netzkino Lua plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://plugins/${PLUGINS_TO_BUILD}/${PLUGINS_TO_BUILD}.lua;beginline=1;endline=24;md5=4fb5aac99d408727fd0f5c63be64fca5"
HOMEPAGE = "http://git.coolstreamtech.de/"
DEPENDS = "lua5.2"
RDEPENDS_${PN} = "lua-json"
SRCREV = "${AUTOREV}"
PV = "0.1+${SRCPV}"


SRC_URI = "git://coolstreamtech.de/cst-public-plugins-scripts-lua.git \
"

S = "${WORKDIR}/git"
PLUGINS_TO_BUILD = "netzkino"
do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 755 ${S}/plugins/${PLUGINS_TO_BUILD}/${PLUGINS_TO_BUILD}.* ${D}/var/tuxbox/plugins
}




