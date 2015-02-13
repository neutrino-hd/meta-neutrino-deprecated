DESCRIPTION = "xupnpd Lua plugins"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://plugins/ard_mediathek/ard_mediathek.lua;beginline=1;endline=20;md5=cc9f2ac0e48626fcc38baccfc9344558"
HOMEPAGE = "http://git.coolstreamtech.de/"
RDEPENDS_${PN} = "xupnpd curl"

inherit gitpkgv

SRCREV = "${AUTOREV}"
PV = "${GITPKGVTAG}"


SRC_URI = "git://coolstreamtech.de/cst-public-plugins-scripts-lua.git \
	   file://0001-xupnpd_youtube_fix.patch \
"

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/usr/share/xupnpd/plugins
	install -m 644 ${S}/xupnpd/xupnpd_18plus.lua ${D}/usr/share/xupnpd/plugins/
	install -m 644 ${S}/xupnpd/xupnpd_cczwei.lua ${D}/usr/share/xupnpd/plugins/
	install -m 644 ${S}/xupnpd/xupnpd_coolstream.lua ${D}/usr/share/xupnpd/plugins/
	install -m 644 ${S}/xupnpd/xupnpd_youtube.lua ${D}/usr/share/xupnpd/plugins/
}

FILES_${PN} = "\
    /usr/share/xupnpd/plugins \
"



