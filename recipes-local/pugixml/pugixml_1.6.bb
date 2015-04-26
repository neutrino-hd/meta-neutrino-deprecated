inherit autotools gettext
SUMMARY = "XML Parser library "
HOMEPAGE = "https://github.com/zeux/pugixml"
LICENSE = "MIT"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Package Revision (update whenever recipe is changed)
PR = "r0"

TARGET_CC_ARCH += "${LDFLAGS}"

SRC_URI = "http://github.com/zeux/pugixml/releases/download/v1.6/pugixml-1.6.tar.gz \
	   file://001_Makefile.patch \
"

SRC_URI[md5sum] = "7fe3667bb6bf123f65cdf2f5cfe4732f"
SRC_URI[sha256sum] = "473705c496d45ee6a74f73622b175dfb5dde0de372c4dc61a5acb964516cd9de"

S = "${WORKDIR}/${PN}-${PV}"

inherit autotools pkgconfig

do_compile () {
    oe_runmake
    rm -f *.o
}

