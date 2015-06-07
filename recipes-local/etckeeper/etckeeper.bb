
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

RDEPENDS_${PN} += "git findutils cronie perl-module-file-glob"

SRC_URI = "git://github.com/joeyh/etckeeper.git;branch=master \
	   file://etckeeper \
	   file://etckeeper.conf \
	   file://0001-use-systemwide-gitconfig-to-correct-commiter-name-an.patch \
"

SRC_URI[md5sum] = "439d65fc487910a30b686788b7c6fc99"
SRC_URI[sha256sum] = "76fd0349ff138b98a4dde831a23a13d3fc6608147ef4fef35ce58ebf48f18f23"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

S = "${WORKDIR}/git"

inherit autotools-brokensep 
	
do_install_append () {
	install -d ${D}${sysconfdir}/cron.daily/
	install -m755 ${WORKDIR}/etckeeper ${D}/etc/cron.daily/etckeeper
	install -m644 ${WORKDIR}/etckeeper.conf ${D}/etc/etckeeper
}

