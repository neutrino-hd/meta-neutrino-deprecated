require ntp.inc

PR = "r1"

SRC_URI = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${P}.tar.gz \
        file://ntp-4.2.4_p6-nano.patch \
        file://ntpd \
        file://ntp.conf \
        file://ntpdate"

SRC_URI[md5sum] = "60049f51e9c8305afe30eb22b711c5c6"
SRC_URI[sha256sum] = "583d0e1c573ace30a9c6afbea0fc52cae9c8c916dbc15c026e485a0dda4ba048"

INITSCRIPT_NAME = "ntpd"

EXTRA_OECONF += " --with-net-snmp-config=no --without-ntpsnmpd --with-yielding-select=yes"

CONFFILES_${PN} = "${sysconfdir}/ntp.conf"

do_install_append() {
        install -d ${D}/${sysconfdir}/init.d
        install -m 644 ${WORKDIR}/ntp.conf ${D}/${sysconfdir}
        install -m 755 ${WORKDIR}/ntpd ${D}/${sysconfdir}/init.d
        install -d ${D}/${sysconfdir}/network/if-up.d
        install -m 755 ${WORKDIR}/ntpdate ${D}/${sysconfdir}/network/if-up.d
}

FILES_${PN} = "${bindir}/ntpd ${sbindir}/ntpd ${sysconfdir}/ntp.conf ${sysconfdir}/init.d/ntpd"
FILES_ntpdate = "${bindir}/ntpdate ${sbindir}/ntpdate ${sysconfdir}/network/if-up.d/ntpdate"
FILES_ntp-utils = "${bindir} ${sbindir} ${libdir}/ntp ${datadir}/ntp"

RDEPENDS_${PN}-utils = "perl libevent bash perl-module-lib perl-module-version perl-module-socket perl-module-getopt-long"
RDEPENDS_${PN} = "${PN}-tickadj libcap perl"

pkg_postinst_ntpdate() {
if test "x$D" != "x"; then
        exit 1
elif [ ! -e /usr/bin/crontab ];then
	exit 0
else
        if ! grep -q -s ntpdate /var/spool/cron/root; then
		echo "adding cronjob"
		(crontab -l 2>/dev/null; echo "30  * 	* * *	root	/usr/bin/ntpdate -b -s -u 0.de.pool.ntp.org") | crontab -
       	fi
fi
}

