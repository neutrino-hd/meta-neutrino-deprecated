FILESEXTRAPATHS_prepend := "${THISDIR}/cronie:"

SRC_URI += "file://root \
"

do_install_append() {
	install -d ${D}/var/spool/cron/
	install -m 644 ${WORKDIR}/root ${D}/var/spool/cron/
}

FILES_${PN}_append += "\
	/var \
"
