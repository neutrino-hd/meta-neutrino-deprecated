DESCRIPTION = "htop process monitor"
HOMEPAGE = "http://hisham.hm/htop/"
SECTION = "console/utils"
LICENSE = "GPLv2"

LIC_FILES_CHKSUM = "file://COPYING;md5=c312653532e8e669f30e5ec8bdc23be3"

DEPENDS = "ncurses"
RDEPENDS_${PN} = "ncurses-terminfo"

SRCREV ?= "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

SRC_URI = "git://github.com/hishamhm/htop.git \
	   file://configure_fix_ncurses_test.patch \
"

S = "${WORKDIR}/git"

LDFLAGS_append_libc-uclibc = " -lubacktrace"

inherit autotools


