FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://msmtprc \
	    file://aliases \
"

HOST_gmx = "mail.gmx.net"
HOST_t-online = "securesmtp.t-online.de"
HOST_gmail = "smtp.gmail.com"
HOST_web.de = "smtp.web.de"
HOST_aol = "smtp.de.aol.com"
HOST_mail.de = "smtp.mail.de"
HOST_outlook = "smtp-mail.outlook.com"

do_install_prepend() {
	install -d ${D}/${sysconfdir}
	install -m 600 ${WORKDIR}/msmtprc ${D}${sysconfdir}/msmtprc
	install -m 644 ${WORKDIR}/aliases ${D}${sysconfdir}/aliases
}

do_install_append() {
	echo "# ${PROVIDER}" >> ${D}${sysconfdir}/msmtprc
	echo "account ${PROVIDER}" >> ${D}${sysconfdir}/msmtprc
	echo "host ${HOST_${PROVIDER}}" >> ${D}${sysconfdir}/msmtprc
	echo "from ${MAIL}" >> ${D}${sysconfdir}/msmtprc
	echo "user ${MAIL}" >> ${D}${sysconfdir}/msmtprc
	echo "password ${PASSWD}" >> ${D}${sysconfdir}/msmtprc
	echo "\n# default account" >> ${D}${sysconfdir}/msmtprc
	echo "account default : ${PROVIDER}" >> ${D}${sysconfdir}/msmtprc
}
