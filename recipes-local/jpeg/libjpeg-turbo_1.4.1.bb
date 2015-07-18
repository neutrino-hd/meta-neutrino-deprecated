DESCRIPTION = "libjpeg-turbo is a derivative of libjpeg that uses SIMD instructions (MMX, SSE2, NEON) to accelerate baseline JPEG compression and decompression"
HOMEPAGE = "http://libjpeg-turbo.org/"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"

SRC_URI = "http://sourceforge.net/projects/libjpeg-turbo/files/${PV}/libjpeg-turbo-${PV}.tar.gz"

SRC_URI[md5sum] = "b1f6b84859a16b8ebdcda951fa07c3f2"
SRC_URI[sha256sum] = "4bf5bad4ce85625bffbbd9912211e06790e00fb982b77724af7211034efafb08"

# Drop-in replacement for jpeg
PROVIDES = "jpeg"
RPROVIDES_${PN} += "jpeg"
RREPLACES_${PN} += "jpeg"
RCONFLICTS_${PN} += "jpeg"

inherit autotools pkgconfig

# EXTRA_OECONF = "--with-jpeg8 "

PACKAGES =+ "jpeg-tools libturbojpeg"

DESCRIPTION_jpeg-tools = "The jpeg-tools package includes the client programs for access libjpeg functionality.  These tools allow for the compression, decompression, transformation and display of JPEG files."
FILES_jpeg-tools = "${bindir}/*"

FILES_libturbojpeg = "${libdir}/libturbojpeg.so.*"

BBCLASSEXTEND = "native"
DEPENDS = "nasm-native"
