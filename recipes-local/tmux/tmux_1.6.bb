DESCRIPTION = "Terminal multiplexer"
HOMEPAGE = "http://tmux.sourceforge.net"
SECTION = "console/utils"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://tmux.c;startline=3;endline=17;md5=f36d9c9e6c1c24996a88891fdf783d04"

DEPENDS = "ncurses libevent sed-native"

SRC_URI = "${SOURCEFORGE_MIRROR}/tmux/${P}.tar.gz \
	   file://tmux-mc \
	   file://tmux.conf \	
"

SRC_URI[md5sum] = "3e37db24aa596bf108a0442a81c845b3"
SRC_URI[sha256sum] = "faee08ba1bd8c22537cd5b7458881d1bdb4985df88ed6bc5967c56881a7efbd6"

inherit autotools pkgconfig

do_configure_prepend () {
    sed -i -e 's:-I/usr/local/include::' ${S}/Makefile.am || bb_fatal "sed failed"
}

do_install_append () {
	install -d ${D}/${bindir} ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/tmux-mc ${D}/${bindir}/
	install -m 644 ${WORKDIR}/tmux.conf ${D}${sysconfdir}/
}
