DESCRIPTION = "tuxbox plugins, ported to neutrino-hd"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"


DEPENDS = "freetype ffmpeg zlib libxml2 virtual/libiconv openssl libpng curl giflib libjpeg-turbo"

SRCREV_autotools = "${AUTOREV}"
SRCREV_tuxcom = "${AUTOREV}"
SRCREV_msgbox = "${AUTOREV}"
SRCREV_input = "${AUTOREV}"
SRCREV_tuxwetter = "${AUTOREV}"
SRCREV_shellexec = "${AUTOREV}"
SRCREV_FORMAT = "autotools"
PV = "8"

SRC_URI = "git://github.com/neutrino-hd/neutrino-hd-plugins.git;branch=master;protocol=https;name=autotools \
	   git://github.com/tuxbox-neutrino/plugin-tuxcom.git;destsuffix=git/tuxcom;branch=master;name=tuxcom \
	   git://github.com/tuxbox-neutrino/plugin-msgbox.git;destsuffix=git/msgbox;branch=master;name=msgbox \
	   git://github.com/tuxbox-neutrino/plugin-input.git;destsuffix=git/input;branch=master;name=input \
	   git://github.com/tuxbox-neutrino/plugin-shellexec.git;destsuffix=git/shellexec;branch=master;name=shellexec \
	   git://github.com/tuxbox-neutrino/plugin-tuxwetter.git;destsuffix=git/tuxwetter;branch=master;name=tuxwetter \
"

S = "${WORKDIR}/git"

ALLOW_EMPTY_neutrino-plugins = "1"

inherit autotools pkgconfig


EXTRA_OECONF += " \
	--enable-maintainer-mode \
	--with-target=native \
	--with-plugindir=/usr/share/tuxbox/neutrino/plugins \
	--with-boxtype=armbox \
"

EXTRA_OECONF += "--with-configdir=/etc/neutrino/config"

N_CFLAGS = "-Wall -W -Wshadow -g -O2 -funsigned-char -I${STAGING_INCDIR}/freetype2"
N_CXXFLAGS = "${N_CFLAGS}"
N_LDFLAGS += "-Wl,--hash-style=gnu -Wl,-rpath-link,${STAGING_DIR_HOST}${libdir},-lfreetype -lcrypto -lssl -lpng -lcurl -lz"

do_compile () {
	unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS
	oe_runmake CFLAGS="${N_CFLAGS}" CXXFLAGS="${N_CXXFLAGS}" LDFLAGS="${N_LDFLAGS}" SUBDIRS="${PLUGIN_INSTALL}"
}

do_install () {
	for i in ${PLUGIN_INSTALL}; do
		oe_runmake install SUBDIRS="$i" DESTDIR=${D}
	done
}			

do_install_append() {
	rm -f ${D}/usr/share/tuxbox/neutrino/plugins/*.la
}

FILES_${PN} = "/usr \
	       /etc \
"

FILES_${PN}-dbg += "/usr/share/tuxbox/neutrino/plugins/.debug"

SRC_URI[md5sum] = "f04cf2dddc22af9f12685f4d4dda0067"
SRC_URI[sha256sum] = "f3ad02f2e43afca3da474bfeccd70808ca9651858893eff0b90891067284b0b8"

