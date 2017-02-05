SUMMARY = "XML Parser library "
HOMEPAGE = "https://github.com/zeux/pugixml"
LICENSE = "MIT"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

# Package Revision (update whenever recipe is changed)
PR = "r0"

TARGET_CC_ARCH += "${LDFLAGS}"

SRC_URI = "http://github.com/zeux/pugixml/releases/download/v${PV}/pugixml-${PV}.tar.gz \
	   file://001_Makefile.patch \
"

SRCSRC_URI[md5sum] = "ffa59ee4853958e243050e6b690b4f2e"
SRC_URI[sha256sum] = "8ef26a51c670fbe79a71e9af94df4884d5a4b00a2db38a0608a87c14113b2904"


S = "${WORKDIR}/${PN}-${PV}"

inherit autotools pkgconfig gettext

do_compile () {
    oe_runmake
    rm -f *.o
}

