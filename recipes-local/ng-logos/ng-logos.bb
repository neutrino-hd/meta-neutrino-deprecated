DESCRIPTION = "ng Logos"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://www.ng-return.com/wbb2/index.php?page=Thread&postID=334856#post334856"

S = "${WORKDIR}/ng_logobasis300"

PR = "r2"

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

SRC_URI[md5sum] = "e9b0e15307c52d5386fe42ff22498658"
SRC_URI[sha256sum] = "7191a6f3e8d5b3214739addb0957040d5030608b3d95faf38530481836b8d645"

