DESCRIPTION = "Terminal multiplexer"
HOMEPAGE = "http://tmux.sourceforge.net"
SECTION = "console/utils"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://tmux.c;startline=3;endline=17;md5=75758f698fa88e729278d7f662bec19e"

DEPENDS = "ncurses libevent sed"

SRC_URI = "${SOURCEFORGE_MIRROR}/tmux/${P}.tar.gz \
	   file://tmux.sh \
	   file://tmux.conf \	
"

SRC_URI[md5sum] = "9fb6b443392c3978da5d599f1e814eaa"
SRC_URI[sha256sum] = "795f4b4446b0ea968b9201c25e8c1ef8a6ade710ebca4657dd879c35916ad362"

inherit autotools-brokensep pkgconfig

do_configure_prepend () {
    sed -i -e 's:-I/usr/local/include::' ${S}/Makefile.am || bb_fatal "sed failed"
}

do_install_append () {
	install -d ${D}/${bindir} ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/tmux.sh ${D}/${bindir}/
	install -m 644 ${WORKDIR}/tmux.conf ${D}${sysconfdir}/
}
