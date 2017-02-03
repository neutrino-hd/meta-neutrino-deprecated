DESCRIPTION = "lua-cURL"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
HOMEPAGE = "https://github.com/Lua-cURL/Lua-cURLv2"
DEPENDS += "curl lua"
RDEPENDS_${PN} += "lua"

S = "${WORKDIR}/git"
SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

SRC_URI = "git://github.com/Lua-cURL/Lua-cURLv2.git \
"

inherit cmake

EXTRA_OECMAKE = " \
		 -DUSE_LUA52="1" \
"

do_install () {
	install -d ${D}${libdir}/lua/5.2
	install -m 755 ${WORKDIR}/build/cURL.so ${D}${libdir}/lua/5.2
}

FILES_${PN} += "${libdir}/lua/5.2/cURL.so"
FILES-dbg_${PN} += "${libdir}/lua/5.2/.debug/cURL.so"
