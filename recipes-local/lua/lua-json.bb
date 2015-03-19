DESCRIPTION = "Lua json Parser"
LICENSE = "CC-BY-3.0"
LIC_FILES_CHKSUM = "file://share/lua/5.2/json.lua;beginline=1;endline=15;md5=4467853ca00b8168ae59f69f6177a64f"
HOMEPAGE = "http://git.coolstreamtech.de/"
DEPENDS="lua5.2"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"

SRC_URI = "git://git.slknet.de/git/cst-public-plugins-scripts-lua.git \
"

S = "${WORKDIR}/git"

FILES_${PN} += "/usr/share/lua/5.2"

do_install () {
	install -d ${D}/usr/share/lua/5.2/
	install -m 755 ${S}/share/lua/5.2/json.lua ${D}/usr/share/lua/5.2/json.lua
}




