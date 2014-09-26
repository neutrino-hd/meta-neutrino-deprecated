DESCRIPTION = "Lua json Parser"
LICENSE = "GPL"
LIC_FILES_CHKSUM = "file://plugins/ard_mediathek/ard_mediathek.lua;beginline=1;endline=20;md5=cc9f2ac0e48626fcc38baccfc9344558"
HOMEPAGE = "http://git.coolstreamtech.de/"
DEPENDS="lua5.2"
SRCREV = "${AUTOREV}"
PV = "0.0+git${SRCPV}"


SRC_URI = "git://coolstreamtech.de/cst-public-plugins-scripts-lua.git \
"

S = "${WORKDIR}/git"

FILES_${PN} += "/usr/share/lua/5.2"

do_install () {
	install -d ${D}/usr/share/lua/5.2/
	install -m 755 ${S}/share/lua/5.2/json.lua ${D}/usr/share/lua/5.2/json.lua
}




