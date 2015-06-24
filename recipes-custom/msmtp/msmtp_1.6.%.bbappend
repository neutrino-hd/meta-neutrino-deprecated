FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://msmtprc \
	    file://aliases \
"

do_install_prepend() {
	sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/msmtprc
	sed -i "s|PASSWD|${PASSWD}|" ${WORKDIR}/msmtprc
	sed -i "s|PROVIDER|${PROVIDER}|" ${WORKDIR}/msmtprc
	sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/aliases
	install -d ${D}/${sysconfdir}
	install -m 600 ${WORKDIR}/msmtprc ${D}${sysconfdir}/msmtprc
	install -m 644 ${WORKDIR}/aliases ${D}${sysconfdir}/aliases
}
