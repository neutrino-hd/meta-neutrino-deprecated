DESCRIPTION = "Terminal multiplexer"
HOMEPAGE = "http://tmux.sourceforge.net"
SECTION = "console/utils"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://tmux.c;startline=3;endline=17;md5=75758f698fa88e729278d7f662bec19e"

DEPENDS = "ncurses libevent sed"

SRC_URI = "git://github.com/tmux/tmux.git;branch=master \
	   file://tmux.sh \
	   file://tmux.conf \	
"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

S = "${WORKDIR}/git"

inherit autotools-brokensep pkgconfig

do_install_append () {
	install -d ${D}/${bindir} ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/tmux.sh ${D}/${bindir}/
	install -m 644 ${WORKDIR}/tmux.conf ${D}${sysconfdir}/
}
