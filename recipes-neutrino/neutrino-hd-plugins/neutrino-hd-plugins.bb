DESCRIPTION = "tuxbox plugins, ported to neutrino-hd"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://tuxcom/tuxcom.c;beginline=10;endline=24;md5=8cfd78763de33face1d26b11904e84d5"
DEPENDS = "freetype ffmpeg zlib libxml2 virtual/libiconv"
SRCREV = "${AUTOREV}"
PV = "6"

SRC_URI = "git://github.com/MarkusVolk/neutrino-hd-plugins.git \
"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

EXTRA_OECONF += " \
	--enable-maintainer-mode \
	--with-target=native \
	--with-configdir=/var/tuxbox/config \
	--with-plugindir=/var/tuxbox/plugins \
	--with-boxtype=coolstream \
"

N_CFLAGS = "-Wall -W -Wshadow -g -O2 -funsigned-char -I${STAGING_INCDIR}/freetype2"
N_CXXFLAGS = "${N_CFLAGS}"
N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}${libdir},-lfreetype"

do_compile () {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
	oe_runmake CFLAGS="${N_CFLAGS}" CXXFLAGS="${N_CXXFLAGS}" LDFLAGS="${N_LDFLAGS}" SUBDIR="msgbox ${PLUGIN_INSTALL}"
}

do_install () {
	for i in msgbox ${PLUGIN_INSTALL}; do
		oe_runmake install SUBDIR="$i" DESTDIR=${D}
	done
}			

FILES_${PN}-dbg += "/var/tuxbox/plugins/.debug"

SRC_URI[md5sum] = "f04cf2dddc22af9f12685f4d4dda0067"
SRC_URI[sha256sum] = "f3ad02f2e43afca3da474bfeccd70808ca9651858893eff0b90891067284b0b8"
