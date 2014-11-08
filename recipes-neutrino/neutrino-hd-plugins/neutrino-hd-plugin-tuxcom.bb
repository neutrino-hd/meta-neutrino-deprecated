DESCRIPTION = "tuxbox plugins, ported to neutrino-hd \
"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://tuxcom/tuxcom.c;beginline=10;endline=24;md5=8cfd78763de33face1d26b11904e84d5"
HOMEPAGE = "https://gitorious.org/neutrino-hd/neutrino-hd-plugins"

SRCREV = "${AUTOREV}"
PV = "1.17+${SRCPV}"
# does not work like that?
# PV_nhd-plugin-tuxcom = "1.17"

SRC_URI = "git://gitorious.org/neutrino-hd/neutrino-hd-plugins.git \
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

N_CFLAGS = "-Wall -W -Wshadow -g -O2 -funsigned-char"
N_CXXFLAGS = "${N_CFLAGS}"
N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}${libdir}"

PLUGINS_TO_BUILD = "tuxcom"

do_compile () {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
	oe_runmake CFLAGS="${N_CFLAGS}" CXXFLAGS="${N_CXXFLAGS}" LDFLAGS="${N_LDFLAGS}" SUBDIRS="${PLUGINS_TO_BUILD}"
}

do_install () {
	for i in ${PLUGINS_TO_BUILD}; do
		oe_runmake install SUBDIRS="$i" DESTDIR=${D}
	done
}


FILES_${PN} =  "/var/tuxbox/plugins/tuxcom.so \
		/var/tuxbox/plugins/tuxcom.cfg \
"

FILES_${PN}-dev = "/var/tuxbox/config"
FILES_${PN}-dbg += "/var/tuxbox/plugins/.debug"
