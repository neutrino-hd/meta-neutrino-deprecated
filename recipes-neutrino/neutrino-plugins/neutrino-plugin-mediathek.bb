FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DESCRIPTION = "Mediathek Lua plugin"
MAINTAINER = "Michael Liebmann"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "https://slknet.de/"
DEPENDS = "lua"
RDEPENDS_${PN} = "lua-json luaposix"

PV = "0.12"

SRC_URI = "git://git.tuxcode.de/mediathek-luaV2.git;branch=master;protocol=https \
"
SRCREV = "${AUTOREV}"
S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/var/tuxbox/plugins ${D}/usr/share
	cp -rf ${S}/share ${D}/usr/
        cp -rf ${S}/coolithek* ${D}/var/tuxbox/plugins
}

FILES_${PN} += "/usr/share/*"

