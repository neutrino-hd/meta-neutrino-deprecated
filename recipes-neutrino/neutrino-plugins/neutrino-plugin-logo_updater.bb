DESCRIPTION = "ng Logoupdater"
LICENSE = "proprietary"
MAINTAINER = "Fred Feuerstein"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://www.ng-return.com/wbb2/index.php?page=Thread&postID=334856#post334856"

S = "${WORKDIR}"

PR = "r2"

SRC_URI = "file://logo-addon.sh \
	   file://logo-addon_hint.png \
	   file://logo-addon.cfg \
	   file://license \
"

do_install () {
	install -d ${D}/var/tuxbox/plugins
	install -m 755 ${S}/logo-addon.sh ${D}/var/tuxbox/plugins
	install -m 644 ${S}/logo-addon.cfg ${D}/var/tuxbox/plugins
	install -m 644 ${S}/logo-addon_hint.png ${D}/var/tuxbox/plugins
}

SRC_URI[md5sum] = "3deaec355c83e96390558d503ab8c7f7"
SRC_URI[sha256sum] = "007ba5db4f146d9ca443fe5f2dffa73d36a9b239848469b3abaea490f30bb881"



