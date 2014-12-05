DESCRIPTION = "lua-feedparser"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://LICENCE;md5=b8e3c7d92765c11f200410b0e53c8bdb"
HOMEPAGE = "https://github.com/slact/lua-feedparser"

RDEPENDS_${PN} += "lua5.2"
SRCREV = "${AUTOREV}"
PR = "r1"
S = "${WORKDIR}/git"

SRC_URI = "git://github.com/slact/lua-feedparser.git;protocol=git;branch=master"

SRC_URI[md5sum] = "9da3eb618aaf1547a1a75504c8185cee"
SRC_URI[sha256sum] = "efe74a0ff7375ee5fe459aefff723c0efd5ebba7d05de34f7ebc334147c0731b"

LUA_SHARE_DIR = "${datadir}/lua/5.2"

FILES_${PN} = "${LUA_SHARE_DIR}/*"
	       

do_install() {
		install -d -m 0644 ${D}/${LUA_SHARE_DIR} ${D}/${LUA_SHARE_DIR}/feedparser 
		install -D -m 0644 ${S}/feedparser.lua ${D}${LUA_SHARE_DIR}
		install -D -m 0644 ${S}/feedparser/* ${D}${LUA_SHARE_DIR}/feedparser/
}

