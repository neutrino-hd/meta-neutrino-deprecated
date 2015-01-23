#COMPATIBLE_MACHINE = "coolstream-hd2"
SUMMARY = "Extra machine specific configuration files"
DESCRIPTION = "Extra machine specific configuration files for udev, specifically blacklist information."
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING.GPL;md5=751419260aa954499f7abaabaa882bbe"

PR = "r2"

SRC_URI = "file://mount.blacklist \
           file://COPYING.GPL \
	   file://media-tmpfs.sh \
	   file://udev-blockdev.sh \
	   file://mount.sh \
"

do_install () {
	install -d ${D}${sysconfdir}/udev/
	install -m 0644 ${WORKDIR}/mount.blacklist ${D}${sysconfdir}/udev/
}

do_install_append() {
	install -D -m 0755 ${WORKDIR}/media-tmpfs.sh ${D}${sysconfdir}/init.d/aa_media-tmpfs.sh
	install -D -m 0755 ${WORKDIR}/udev-blockdev.sh ${D}${sysconfdir}/init.d/zz_udev-blockdev.sh
	# needs to run after S02sysfs.sh and before S03udev -> call it aa_media...
	update-rc.d -r ${D} aa_media-tmpfs.sh start 03 S .
	# needs to run after S03udev -> zz_udev...
	update-rc.d -r ${D} zz_udev-blockdev.sh start 03 S .
}

do_install_prepend_coolstream-hd1 () {
	sed -i '5a ${@'/dev/sda' if DISTRO != 'coolstream-hd1_flash' else '#/dev/sda'}' ${WORKDIR}/mount.blacklist
}

FILES_${PN} += " \
	${sysconfdir}/init.d \
	${sysconfdir}/rcS.d \
"
