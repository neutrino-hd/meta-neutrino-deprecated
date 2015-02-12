# directory must be accessible from beginning, therefore we cannot use /var/run

do_install_append () {
	sed -i 's|/var/run|/run|' ${D}${sysconfdir}/udev/udev.conf
}
