DESCRIPTION = "Terminal multiplexer"
HOMEPAGE = "http://tmux.sourceforge.net"
SECTION = "console/utils"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://tmux.c;startline=3;endline=17;md5=e109dd9b5e4d23291d87e1e9bc95231c"

DEPENDS = "ncurses libevent sed-native"

SRC_URI = "${SOURCEFORGE_MIRROR}/tmux/${P}.tar.gz \
	   file://tmux.sh \
	   file://tmux.conf \	
"

SRC_URI[md5sum] = "b07601711f96f1d260b390513b509a2d"
SRC_URI[sha256sum] = "c5e3b22b901cf109b20dab54a4a651f0471abd1f79f6039d79b250d21c2733f5"

inherit autotools-brokensep pkgconfig

do_configure_prepend () {
    sed -i -e 's:-I/usr/local/include::' ${S}/Makefile.am || bb_fatal "sed failed"
}

do_install_append () {
	install -d ${D}/${bindir} ${D}${sysconfdir}/
	install -m 755 ${WORKDIR}/tmux.sh ${D}/${bindir}/
	install -m 644 ${WORKDIR}/tmux.conf ${D}${sysconfdir}/
}
