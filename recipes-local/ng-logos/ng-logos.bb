DESCRIPTION = "ng Logos"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://www.ng-return.com/wbb2/index.php?page=Thread&postID=334856#post334856"

S = "${WORKDIR}/ng_logos270"

PR = "r1"

SRC_URI = "http://wget.biz/logos/ng_logobasis.zip \
	   file://license \
"
do_install() {
    install -d ${D}/usr/share/tuxbox/neutrino/icons/logo
    install -m 0644 ${S}/* ${D}/usr/share/tuxbox/neutrino/icons/logo/
}

FILES_${PN} = "\
    /usr/share/tuxbox/neutrino/icons/logo \
"

SRC_URI[md5sum] = "6113d1c4cb4717d651924639a460ba41"
SRC_URI[sha256sum] = "5549e6e2ac598a9e951396c01fa6ee93b7125f695a2b0eb2e1a219fbc0bce1e3"

