DESCRIPTION = "A utility program for spinning-down external disks after a period of idle time"
HOMEPAGE = "http://hd-idle.sourceforge.net/"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
DEPENDS = ""
PR = "1"

INITSCRIPT_NAME = ""
INITSCRIPT_PARAMS = "defaults"

inherit autotools-brokensep

EXTRA_OECONF = "--with-external-libupnp"

SRC_URI = "${SOURCEFORGE_MIRROR}/project/hd-idle/hd-idle-1.04.tgz \
"

S = "${WORKDIR}/hd-idle"

SRC_URI[md5sum] = "41e52e669fc59fa82ee0c2bcce1336d3"
SRC_URI[sha256sum] = "308e90104d7ee8124db50dc9b0d8c61c6afc65d524de2e75f76d84f80674fbdc"

