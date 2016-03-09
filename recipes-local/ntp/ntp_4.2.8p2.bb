require ntp.inc

PR = "r1"

SRC_URI = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${P}.tar.gz \
        file://ntp-4.2.4_p6-nano.patch \
        file://ntpd \
        file://ntp.conf \
        file://ntpdate"

SRC_URI[md5sum] = "fa37049383316322d060ec9061ac23a9"
SRC_URI[sha256sum] = "0d69bc0e95caad43ea04fdad410e756bae1a71e67b1c2bd799b76b55e04c9b31"

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

FILES_${PN}-bin = "${bindir}/ntp-wait ${bindir}/ntpdc ${bindir}/ntpq ${bindir}/ntptime ${bindir}/ntptrace ${bindir}/ntpsweep ${bindir}/sntp ${sbindir}"
FILES_${PN} = "${bindir}/ntpd ${sysconfdir}/ntp.conf ${sysconfdir}/init.d/ntpd"
FILES_${PN}-tickadj = "${bindir}/tickadj ${bindir}/calc_tickadj"
FILES_ntp-utils = "${bindir}/* ${libdir}/ntp ${datadir}/ntp"
FILES_ntpdate = "${bindir}/ntpdate ${sysconfdir}/network/if-up.d/ntpdate"

# ntp originally includes tickadj. It's split off for inclusion in small firmware images on platforms
# with wonky clocks (e.g. OpenSlug)
RDEPENDS_${PN}-tickadj = "perl"
RDEPENDS_${PN}-utils = "perl libevent bash"
RDEPENDS_${PN}-bin = "perl perl-module-lib perl-module-version perl-module-socket perl-module-getopt-long"
RDEPENDS_${PN} = "${PN}-tickadj libcap perl"

pkg_postinst_ntpdate() {
if test "x$D" != "x"; then
        exit 1
elif [ ! -f /usr/bin/crontab ];then
	exit 0
else
        if ! grep -q -s ntpdate /var/spool/cron/root; then
		echo "adding cronjob"
		(crontab -l 2>/dev/null; echo "30  * 	* * *	root	/usr/bin/ntpdate -b -s -u 0.de.pool.ntp.org") | crontab -
       	fi
fi
}

