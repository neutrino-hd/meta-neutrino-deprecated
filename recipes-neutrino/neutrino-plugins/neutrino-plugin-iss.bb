DESCRIPTION = "ISS-Position Lua Plugin"
MAINTAINER = "theobald123"
HOMEPAGE = "http://www.dbox2world.net/board293-cst-coolstream/board313-cst-coolstream-downloads/board319-coolstream-plugins/12664-lua-iss-position/"

S = "${WORKDIR}"

PR = "r1"

SRC_URI = "file://iss-position.lua \
	   file://iss-position.cfg \
	   file://iss-position_hint.png \
"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 644 ${S}/iss-position.lua ${D}/var/tuxbox/plugins
	install -m 644 ${S}/iss-position.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/iss-position_hint.png ${D}/var/tuxbox/plugins
}
