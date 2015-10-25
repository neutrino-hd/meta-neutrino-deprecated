DESCRIPTION = "ARD Mediathek Lua plugin"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://plugins/ard_mediathek/ard_mediathek.lua;beginline=1;endline=20;md5=cc9f2ac0e48626fcc38baccfc9344558"
HOMEPAGE = "http://git.coolstreamtech.de/"
DEPENDS = "lua5.2"
RDEPENDS_${PN} = "lua-json luaposix"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"


SRC_URI = "git://git.slknet.de/git/cst-public-plugins-scripts-lua.git \
	   file://ARD.png \
"

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 755 ${S}/plugins/ard_mediathek/ard_mediathek.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/plugins/ard_mediathek/ard_mediathek.jpg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/plugins/ard_mediathek/ard_mediathek.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${WORKDIR}/ARD.png ${D}/var/tuxbox/plugins
}

do_install_append () {
echo "hinticon=ARD" >> ${D}/var/tuxbox/plugins/ard_mediathek.cfg
}


