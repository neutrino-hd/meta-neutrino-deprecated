SUMMARY = "XML Parser library "
HOMEPAGE = "https://github.com/zeux/pugixml"
LICENSE = "MIT"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Package Revision (update whenever recipe is changed)
PR = "r0"

TARGET_CC_ARCH += "${LDFLAGS}"

SRC_URI = "http://github.com/zeux/pugixml/releases/download/v1.7/pugixml-1.7.tar.gz \
	   file://001_Makefile.patch \
"

SRC_URI[md5sum] = "17e6a3996de2942629dce65db1a701c5"
SRC_URI[sha256sum] = "fbe10d46f61d769f7d92a296102e4e2bd3ee16130f11c5b10a1aae590ea1f5ca"

S = "${WORKDIR}/${PN}-${PV}"

inherit autotools pkgconfig gettext

do_compile () {
    oe_runmake
    rm -f *.o
}

