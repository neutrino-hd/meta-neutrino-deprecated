
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

RDEPENDS_${PN} += "git findutils util-linux-mountpoint perl-module-file-glob"

SRC_URI = "git://github.com/joeyh/etckeeper.git;branch=master \
	   file://etckeeper.service \
	   file://create-etc.service \
	   file://etckeeper-autocommit.service \
	   file://etckeeper-autocommit.timer \
	   file://etckeeper.sh \
	   file://etckeeper.conf \
	   file://create_etc.sh \
	   file://update_etc.sh \
	   file://0001-use-systemwide-gitconfig-to-correct-commiter-name-an.patch \
"


SRC_URI[md5sum] = "439d65fc487910a30b686788b7c6fc99"
SRC_URI[sha256sum] = "76fd0349ff138b98a4dde831a23a13d3fc6608147ef4fef35ce58ebf48f18f23"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE_${PN} = "etckeeper.service"

inherit autotools-brokensep systemd

do_configure_prepend () {
	sed -i "s|GIT_USER|${GIT_USER}|" ${WORKDIR}/update_etc.sh
	sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/update_etc.sh
	sed -i "s|GIT_URL|${GIT_URL}|" ${WORKDIR}/update_etc.sh
	sed -i "s|GIT_USER|${GIT_USER}|" ${WORKDIR}/create_etc.sh
	sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/create_etc.sh
	sed -i "s|GIT_URL|${GIT_URL}|" ${WORKDIR}/create_etc.sh
}
	
do_install_append () {
	install -d ${D}${systemd_unitdir}/system/timers.target.wants
	install -m 755 ${WORKDIR}/etckeeper.sh ${D}/etc/etckeeper/etckeeper.sh
	install -m 644 ${WORKDIR}/etckeeper.conf ${D}/etc/etckeeper
	install -m 755 ${WORKDIR}/update_etc.sh ${D}/etc/etckeeper/update_etc.sh
	install -m 755 ${WORKDIR}/create_etc.sh ${D}/etc/etckeeper/create_etc.sh
	install -m 644 ${WORKDIR}/create-etc.service ${D}${systemd_unitdir}/system/create-etc.service
	install -m 644 ${WORKDIR}/etckeeper.service ${D}${systemd_unitdir}/system/etckeeper.service
	install -m 644 ${WORKDIR}/etckeeper-autocommit.service ${D}${systemd_unitdir}/system/etckeeper-autocommit.service
	install -m 644 ${WORKDIR}/etckeeper-autocommit.timer ${D}${systemd_unitdir}/system/etckeeper-autocommit.timer
	ln -s /lib/systemd/system/create-etc.service ${D}${systemd_unitdir}/system/timers.target.wants/create-etc.service
	ln -s /lib/systemd/system/etckeeper-autocommit.service ${D}${systemd_unitdir}/system/timers.target.wants/etckeeper-autocommit.service
	rm ${D}/etc/etckeeper/pre-commit.d/README
}

FILES_${PN}_append += "/lib/systemd \
		       /usr/share/bash-completion \
"

