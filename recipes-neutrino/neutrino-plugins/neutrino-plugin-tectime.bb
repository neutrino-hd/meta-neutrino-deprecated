DESCRIPTION = "TecTime Plugin"
LICENSE = "GPL-2.0"
MAINTAINER = "Jacek Jendrzej"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.dbox2world.net/board293-cst-coolstream/board314-cst-coolstream-development/p177045-google-videos-abspielen/#post177045"
DEPENDS = "lua"
RDEPENDS_${PN} += "lua-curl"

S = "${WORKDIR}"

PR = "1"

SRC_URI = "file://TecTime.lua \
	   file://TecTime.cfg \
"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/TecTime.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/TecTime.cfg ${D}/var/tuxbox/plugins
}

FILES_${PN} = "\
    /var/tuxbox/plugins \
"
