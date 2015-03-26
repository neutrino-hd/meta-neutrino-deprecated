DESCRIPTION = "shared library for GIF images"
SECTION = "libs"
LICENSE = "MIT"
PR = "r3"

LIC_FILES_CHKSUM = "file://COPYING;md5=ae11c61b04b2917be39b11f78d71519a"

SRC_URI = "${SOURCEFORGE_MIRROR}/giflib/giflib-${PV}.tar.bz2"
SRC_URI[md5sum] = "1c39333192712788c6568c78a949f13e"
SRC_URI[sha256sum] = "391014aceb21c8b489dc7b0d0b6a917c4e32cc014ce2426d47ca376d02fe2ffc"

inherit autotools lib_package

PACKAGES += "${PN}-utils"

FILES_${PN}-utils = "${bindir}/*"
