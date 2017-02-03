DESCRIPTION = "lua-feedparser"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENCE;md5=b8e3c7d92765c11f200410b0e53c8bdb"
HOMEPAGE = "https://github.com/slact/lua-feedparser"

RDEPENDS_${PN} += "lua"
SRCREV = "${AUTOREV}"
PR = "r1"
S = "${WORKDIR}/git"

SRC_URI = "git://github.com/slact/lua-feedparser.git;protocol=git;branch=master \
	   file://0001-Makefile_fix.patch \
"

SRC_URI[md5sum] = "9da3eb618aaf1547a1a75504c8185cee"
SRC_URI[sha256sum] = "efe74a0ff7375ee5fe459aefff723c0efd5ebba7d05de34f7ebc334147c0731b"


do_install() {
		oe_runmake install DESTDIR=${D}
}

FILES_${PN} += "/usr/share/lua/5.2"



