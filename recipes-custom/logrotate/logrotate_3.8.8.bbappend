FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

RDEPENDS_${PN} = "mailx msmtp"

SRC_URI += "file://logrotate.conf \
	    file://config.h.patch \
"	

do_install_prepend() {
		sed -i "s|/usr/sbin|/usr/bin|" ${S}/examples/logrotate.cron
		sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/logrotate.conf
}

do_install_append() {
	install -m 644 ${WORKDIR}/logrotate.conf ${D}${sysconfdir}
}
