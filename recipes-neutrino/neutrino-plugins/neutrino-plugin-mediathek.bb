FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DESCRIPTION = "Mediathek Lua plugin"
MAINTAINER = "Michael Liebmann"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "https://slknet.de/"
DEPENDS = "lua"
RDEPENDS_${PN} = "lua-json luaposix"

PV = "0.12"


SRC_URI = "file://coolithek.tar.gz \
"

S = "${WORKDIR}"

do_install () {
	install -d ${D}/var/tuxbox/plugins ${D}/var/tuxbox/plugins/coolithek ${D}/var/tuxbox/plugins/coolithek/locale ${D}/usr/share/lua/5.2/
	cp -rf ${WORKDIR}/usr ${D}
        cp -rf ${WORKDIR}/var ${D}
}

FILES_${PN} += "/usr/share/*"

SRC_URI[md5sum] = "f9b7e6c21a6b55245f84e591a2151773"
SRC_URI[sha256sum] = "c5ed25d014a9fcc3c8b8e9fb1af47cd05269424b1ac1e416d770b9956216c29d"
