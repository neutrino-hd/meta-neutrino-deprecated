FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DEPENDS_append = "update-rc.d-native"

SRC_URI += " \
	file://mount.sh \
"

do_install_append() {
	install -D -m 0755 ${WORKDIR}/mount.sh ${D}${sysconfdir}/udev/scripts/mount.sh
}

