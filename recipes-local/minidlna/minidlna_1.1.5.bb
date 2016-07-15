SUMMARY = "lightweight DLNA/UPnP-AV server targeted at embedded systems"
HOMEPAGE = "http://sourceforge.net/projects/minidlna/"
SECTION = "network"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b1a795ac1a06805cf8fd74920bc46b5c"
DEPENDS = "libexif libjpeg-turbo libid3tag flac libvorbis sqlite3 ffmpeg util-linux virtual/libiconv"

PR = "r1"

SRC_URI = "${SOURCEFORGE_MIRROR}/project/minidlna/minidlna/${PV}/minidlna-${PV}.tar.gz \
		file://minidlna*.conf \
		file://minidlna.service \
"

SRC_URI[md5sum] = "1970e553a1eb8a3e7e302e2ce292cbc4"
SRC_URI[sha256sum] = "8477ad0416bb2af5cd8da6dde6c07ffe1a413492b7fe40a362bc8587be15ab9b"

S = "${WORKDIR}/${PN}-${PV}"

inherit autotools-brokensep gettext systemd

PACKAGES =+ "${PN}-utils"

FILES_${PN}-utils = "${bindir}/test*"

CONFFILES_${PN} = "${sysconfdir}/minidlna.conf"

SYSTEMD_SERVICE_${PN} = "minidlna.service"

do_configure_prepend() {
	sed -i "s|Coolstream|${MACHINE}|" ${WORKDIR}/minidlna*.conf
}

do_install_append() {
	install -d ${D}${sysconfdir} ${D}${systemd_unitdir}/system/multi-user.target.wants/
	install -m 644 ${WORKDIR}/minidlna-${DISTRO}.conf ${D}${sysconfdir}/minidlna.conf
	install -m 644 ${WORKDIR}/minidlna.service ${D}${systemd_unitdir}/system/minidlna.service
	ln -sf ${systemd_unitdir}/system/minidlna.service ${D}${systemd_unitdir}/system/multi-user.target.wants/minidlna.service
}

FILES_${PN} += "/lib/systemd/system/multi-user.target.wants/minidlna.service"

pkg_preinst_${PN} () {
	if [ -f /etc/minidlna.conf ];then
		mv /etc/minidlna.conf /etc/minidlna.conf.orig
	fi
}

pkg_postinst_${PN} () {
if [ -f /etc/minidlna.conf.orig ];then
		mv /etc/minidlna.conf.orig /etc/minidlna.conf
	fi
}
