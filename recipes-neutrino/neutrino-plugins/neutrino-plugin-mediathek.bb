DESCRIPTION = "Mediathek Lua plugin"
MAINTAINER = "Michael Liebmann"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "https://slknet.de/"
DEPENDS = "lua5.2"
RDEPENDS_${PN} = "lua-json luaposix"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "0.2"


SRC_URI = "git://git.slknet.de/git/mediathek-luaV2.git;branch=master \
"

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/var/tuxbox/plugins ${D}/var/tuxbox/plugins/coolithek ${D}/var/tuxbox/plugins/coolithek/locale ${D}/usr/share/lua/5.2/
	install -m 644 ${S}/coolithek.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/coolithek.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/share/lua/5.2/* ${D}/usr/share/lua/5.2/
	install -m 644 ${S}/coolithek/*.lua ${D}/var/tuxbox/plugins/coolithek
	install -m 644 ${S}/coolithek/locale/*.lua ${D}/var/tuxbox/plugins/coolithek/locale
}

FILES_${PN} += "/usr/share/*"


