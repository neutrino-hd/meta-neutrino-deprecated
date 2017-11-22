DESCRIPTION = "Neutrino Lua RSS Reader"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = ""
MAINTAINER = "Jacek Jendrzej"
DEPENDS = "lua expat"
RDEPENDS_${PN} = "lua-expat lua-feedparser lua-curl"

PV = "0.50"
PR = "1"


SRC_URI = "file://rss.tar.gz \
"

S = "${WORKDIR}"

do_install () {
	install -d ${D}/etc/neutrino/plugins/rss_addon ${D}/etc/neutrino/config
	install -m 644 ${S}/rss.lua ${D}/etc/neutrino/plugins
	install -m 644 ${S}/rss.cfg ${D}/etc/neutrino/plugins
	install -m 644 ${S}/rss_addon/* ${D}/etc/neutrino/plugins/rss_addon
	install -m 644 ${S}/rss_icon.png ${D}/etc/neutrino/plugins
	install -m 644 ${S}/rssreader.conf ${D}/etc/neutrino/config
}




