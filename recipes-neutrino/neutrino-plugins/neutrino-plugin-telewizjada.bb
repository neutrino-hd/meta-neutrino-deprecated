DESCRIPTION = "Add telewizjada"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
MAINTAINER = "satbaby"
HOMEPAGE = "http://www.ng-return.com/wbb2/index.php?page=Thread&threadID=46471"

S = "${WORKDIR}"

PR = "r1"

SRC_URI = "file://telewizjada.xml \
	   file://telewizjada.lua \
	   file://license \
"

do_install () {
	install -d ${D}/etc/neutrino/config
	install -m 644 ${S}/telewizjada.xml ${D}/etc/neutrino/config
	install -d ${D}/var/tuxbox/plugins/webtv
	install -m 644 ${S}/telewizjada.lua ${D}/var/tuxbox/plugins/webtv
}
