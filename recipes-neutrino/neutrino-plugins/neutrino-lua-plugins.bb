DESCRIPTION = "Add webtv.xml listings"
LICENSE = "GPL-2.0"
MAINTAINER = "bazi98"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "https://github.com/tuxbox-neutrino"

S = "${WORKDIR}/git"

PR = "r1"

SRC_URI = "git://github.com/tuxbox-neutrino/plugin-scripts-lua.git;protocol=https \
		   file://yt_live.tar.gz \
		   file://webtv.tar.gz \
"

SRCREV = "${AUTOREV}"

do_install () {
	install -d ${D}/etc/neutrino/plugins/webtv ${D}/usr/share/xupnpd/plugins
	install -m 644 ${S}/plugins/webtv/yt_live.xml ${D}/etc/neutrino/plugins/webtv
	install -m 644 ${WORKDIR}/webtv_ora.xml ${D}/etc/neutrino/plugins/webtv
	install -m 644 ${WORKDIR}/webtv_localtv.xml ${D}/etc/neutrino/plugins/webtv
	install -m 644 ${WORKDIR}/yt_live.cfg ${D}/etc/neutrino/plugins
	install -m 644 ${WORKDIR}/yt_live.png ${D}/etc/neutrino/plugins
	install -m 644 ${S}/plugins/webtv/yt_live.lua ${D}/etc/neutrino/plugins/
	install -m 644 ${S}/plugins/mtv/* ${D}/etc/neutrino/plugins/
	install -m 644 ${S}/plugins/netzkino/* ${D}/etc/neutrino/plugins/
	install -m 644 ${S}/plugins/ard_mediathek/* ${D}/etc/neutrino/plugins/
	install -m 644 ${S}/xupnpd/* ${D}/usr/share/xupnpd/plugins/
}

FILES_${PN} += " \
	/usr \
"

