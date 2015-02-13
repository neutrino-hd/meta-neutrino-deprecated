DESCRIPTION = "ARD Mediathek Lua plugin"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://plugins/ard_mediathek/ard_mediathek.lua;beginline=1;endline=20;md5=cc9f2ac0e48626fcc38baccfc9344558"
HOMEPAGE = "http://git.coolstreamtech.de/"
DEPENDS = "lua5.2"
RDEPENDS_${PN} = "lua-json luaposix"

inherit gitpkgv

SRCREV = "${AUTOREV}"
PV = "${GITPKGVTAG}"


SRC_URI = "git://coolstreamtech.de/cst-public-plugins-scripts-lua.git \
"

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 755 ${S}/plugins/ard_mediathek/ard_mediathek.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/plugins/ard_mediathek/ard_mediathek.jpg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/plugins/ard_mediathek/ard_mediathek.cfg ${D}/var/tuxbox/plugins
}




