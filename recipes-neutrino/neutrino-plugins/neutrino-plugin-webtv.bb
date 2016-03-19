DESCRIPTION = "Add webtv.xml listings"
LICENSE = "GPL-2.0"
MAINTAINER = "bazi98"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "http://www.dbox2world.net/board293-cst-coolstream/board314-cst-coolstream-development/p177542-optimierung-webtv/#post177542"

S = "${WORKDIR}"

PR = "r1"

SRC_URI = "file://webtv_localtv.xml \
	   file://webtv_ora.xml \
"

do_install () {
	install -d ${D}/etc/neutrino/config
	install -m 644 ${S}/webtv_localtv.xml ${D}/etc/neutrino/config
	install -m 644 ${S}/webtv_ora.xml ${D}/etc/neutrino/config
}
