DESCRIPTION = "xupnpd Lua plugins"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://git.coolstreamtech.de/"
RDEPENDS_${PN} = "xupnpd curl"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"

SRC_URI = "git://github.com/coolstreamtech/cst-public-plugins-scripts-lua.git \
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



