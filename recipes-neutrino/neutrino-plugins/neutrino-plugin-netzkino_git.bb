DESCRIPTION = "Netzkino Lua plugin"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://plugins/${PLUGINS_TO_BUILD}/${PLUGINS_TO_BUILD}.lua;beginline=1;endline=24;md5=4fb5aac99d408727fd0f5c63be64fca5"
HOMEPAGE = "http://git.coolstreamtech.de/"
DEPENDS = "lua"
RDEPENDS_${PN} = "lua-json luaposix"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"


SRC_URI = "git://github.com/coolstreamtech/cst-public-plugins-scripts-lua.git \
"

S = "${WORKDIR}/git"
PLUGINS_TO_BUILD = "netzkino"
do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 755 ${S}/plugins/${PLUGINS_TO_BUILD}/${PLUGINS_TO_BUILD}.* ${D}/var/tuxbox/plugins
}

SRC_URI[md5sum] = "f9b7e6c21a6b55245f84e591a2151773"
SRC_URI[sha256sum] = "c5ed25d014a9fcc3c8b8e9fb1af47cd05269424b1ac1e416d770b9956216c29d"


