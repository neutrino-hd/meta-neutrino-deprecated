DESCRIPTION = "Small, fast and powerful xml library"
AUTHOR = "Tristan Lelong <tristan.lelong@libroxml.net>"
HOMEPAGE = "http://www.libroxml.net"
SECTION = "libs"
PRIORITY = "optional"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780"


SRC_URI[md5sum] = "a975f91be150f7a19168a45ce15769ca"
SRC_URI[sha256sum] = "1da8f20b530eba4409f2b217587d2f1281ff5d9ba45b24aeac71b94c6c621b78"

SRC_URI = "http://download.libroxml.net/pool/v2.x/${P}.tar.gz"

PR = "1"

inherit cmake

EXTRA_OECMAKE = " \ 
	-DCONFIG_XML_READ_WRITE=0 \
	-DCONFIG_XML_SMALL_INPUT_FILE=1 \
	-DCONFIG_XML_COMMIT_XML_TREE=0 \
	-DCONFIG_XML_XPATH_ENGINE=0 \
"

PACKAGES =+ "roxml roxml-dbg"
FILES_roxml = "${bindir}/*"
FILES_roxml-dbg = "${bindir}/.debug/*"



