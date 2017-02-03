DESCRIPTION = "MTV Lua Plugin"
LICENSE = "GPL-2.0"
MAINTAINER = "Jacek Jendrzej"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.dbox2world.net/board293-cst-coolstream/board313-cst-coolstream-downloads/board319-coolstream-plugins/12579-mtv-de-video-plugin-version-0-1/"

DEPENDS = "lua"
RDEPENDS_${PN} += "rtmpdump"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"

S = "${WORKDIR}/git/plugins/mtv"

SRC_URI = "git://github.com/coolstreamtech/cst-public-plugins-scripts-lua.git \
"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/mtv.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/mtv.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/mtv_hint.png ${D}/var/tuxbox/plugins
}

FILES_${PN} = "\
    /var/tuxbox/plugins \
"
SRC_URI[md5sum] = "f9b7e6c21a6b55245f84e591a2151773"
SRC_URI[sha256sum] = "c5ed25d014a9fcc3c8b8e9fb1af47cd05269424b1ac1e416d770b9956216c29d"
