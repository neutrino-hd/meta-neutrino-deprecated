FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://logrotate.conf"

do_install_prepend() {
		sed -i "s|/usr/sbin|/usr/bin|" ${S}/examples/logrotate.cron
}

do_install_append() {
	install -m 644 ${WORKDIR}/logrotate.conf ${D}${sysconfdir}
}
