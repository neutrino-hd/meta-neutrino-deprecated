DESCRIPTION = "GNU nano (Nano's ANOther editor, or \
Not ANOther editor) is an enhanced clone of the \
Pico text editor."
HOMEPAGE = "http://www.nano-editor.org/"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=f27defe1e96c2e1ecd4e0c9be8967949"
SECTION = "console/utils"
DEPENDS = "ncurses"
#RDEPENDS_${PN} = "ncurses-terminfo"

SRC_URI = "http://www.nano-editor.org/dist/v2.7/nano-${PV}.tar.gz"

inherit autotools gettext

#EXTRA_OECONF = "--enable-all"
