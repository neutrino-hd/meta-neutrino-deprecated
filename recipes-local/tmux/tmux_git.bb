DESCRIPTION = "Terminal multiplexer"
HOMEPAGE = "http://tmux.sourceforge.net"
SECTION = "console/utils"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/ISC;md5=f3b90e78ea0cffb20bf5cca7947a896d"

DEPENDS = "ncurses libevent sed"

SRC_URI = "git://github.com/tmux/tmux.git;branch=master \
	   file://tmux.sh \
	   file://tmux.conf \	
"

SRCREV = "1a6e696b08113ca17ee8e881844167cf94276846"
PV = "${SRCPV}"
PR = "1"

S = "${WORKDIR}/git"

inherit autotools-brokensep pkgconfig

do_install_append () {
	install -d ${D}/${bindir} ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/tmux.sh ${D}/${bindir}/
	install -m 644 ${WORKDIR}/tmux.conf ${D}${sysconfdir}/
}
