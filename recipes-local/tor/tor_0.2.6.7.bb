DESCRIPTION = "Tor is a network of virtual tunnels that allows people and groups \
              to improve their privacy and security on the Internet."
HOMEPAGE = "http://tor.eff.org"
SECTION = "console/network"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD;md5=3775480a712fc46a69647678acb234cb"
DEPENDS = "libevent openssl zlib"

SRC_URI = "http://tor.eff.org/dist/${P}.tar.gz \
           file://tor.init"

inherit autotools update-rc.d

INITSCRIPT_NAME = "tor"

EXTRA_OECONF += "--disable-tool-name-check"

do_install_append() {
	install -d ${D}${sysconfdir}/init.d
	install ${WORKDIR}/tor.init ${D}${sysconfdir}/init.d/tor
}

SRC_URI[md5sum] = "a43b4dc6a95d219927aab0a2bb7ed322"
SRC_URI[sha256sum] = "8c2be88a542ed1b22a8d3d595ec0acd0e28191de273dbcaefc64fdce92b89e6c"

