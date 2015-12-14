DESCRIPTION = "ng Logos"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://${WORKDIR}/license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://www.ng-return.com/wbb2/index.php?page=Thread&postID=334856#post334856"

S = "${WORKDIR}/ng_logos300"

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

SRC_URI[md5sum] = "f97aeab4484530ac47628cf0db791fe6"
SRC_URI[sha256sum] = "774dd03bac4ed43c52bc2fedae832b6ba558085fd7d40f48e8d8211923cadf2f"

