DESCRIPTION = "Tor is a network of virtual tunnels that allows people and groups \
              to improve their privacy and security on the Internet."
HOMEPAGE = "http://tor.eff.org"
SECTION = "console/network"
PRIORITY = "optional"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD;md5=3775480a712fc46a69647678acb234cb"
DEPENDS = "libevent openssl zlib socat tsocks"
RDEPENDS_${PN} = "socat tsocks"
SRC_URI = "http://pkgs.fedoraproject.org/repo/pkgs/tor/${P}.tar.gz/cc19107b57136a68e8c563bf2d35b072/${P}.tar.gz\
           file://tor.init \
	   file://tsocks.conf \
"

inherit autotools update-rc.d

INITSCRIPT_NAME = "tor"

EXTRA_OECONF += "--disable-tool-name-check"

do_install_append() {
	install -d ${D}${sysconfdir}/init.d ${D}${sysconfdir}/tor
	install ${WORKDIR}/tor.init ${D}${sysconfdir}/init.d/tor
	install ${WORKDIR}/tsocks.conf ${D}${sysconfdir}/tor/tor-tsocks.conf
}

SRC_URI[md5sum] = "cc19107b57136a68e8c563bf2d35b072"
SRC_URI[sha256sum] = "493a8679f904503048114aca6467faef56861206bab8283d858f37141d95105d"

