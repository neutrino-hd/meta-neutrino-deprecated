require ntp.inc

PR = "r1"

SRC_URI = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${P}.tar.gz \
        file://ntp-4.2.4_p6-nano.patch \
        file://ntpd \
        file://ntp.conf \
        file://ntpdate"

SRC_URI[md5sum] = "fa37049383316322d060ec9061ac23a9"
SRC_URI[sha256sum] = "0d69bc0e95caad43ea04fdad410e756bae1a71e67b1c2bd799b76b55e04c9b31"


EXTRA_OECONF += " --with-net-snmp-config=no --without-ntpsnmpd --with-yielding-select=yes"

CONFFILES_${PN} = "${sysconfdir}/ntp.conf"

do_install_append() {
        install -d ${D}/${sysconfdir}/init.d
        install -m 644 ${WORKDIR}/ntp.conf ${D}/${sysconfdir}
        install -m 755 ${WORKDIR}/ntpd ${D}/${sysconfdir}/init.d
        install -d ${D}/${sysconfdir}/network/if-up.d
        install -m 755 ${WORKDIR}/ntpdate ${D}/${sysconfdir}/network/if-up.d
}

FILES_${PN}-bin = "${bindir}/ntp-wait ${bindir}/ntpdc ${bindir}/ntpq ${bindir}/ntptime ${bindir}/ntptrace ${bindir}/ntpsweep ${bindir}/sntp"
FILES_${PN} = "${sbindir}/ntpd ${sysconfdir}/ntp.conf ${sysconfdir}/init.d/ntpd"
FILES_${PN}-tickadj = "${sbindir}/tickadj ${sbindir}/calc_tickadj"
FILES_ntp-utils = "${sbindir}/* ${libdir}/ntp ${datadir}/ntp"
FILES_ntpdate = "${sbindir}/ntpdate ${sysconfdir}/network/if-up.d/ntpdate"

# ntp originally includes tickadj. It's split off for inclusion in small firmware images on platforms
# with wonky clocks (e.g. OpenSlug)
RDEPENDS_${PN}-tickadj = "perl"
RDEPENDS_${PN}-utils = "perl libevent bash"
RDEPENDS_${PN}-bin = "perl"
RDEPENDS_${PN} = "${PN}-tickadj libcap perl"

pkg_postinst_ntpdate() {
if test "x$D" != "x"; then
        exit 1
else
        if ! grep -q -s ntpdate /var/cron/tabs/root; then
                echo "adding crontab"
                test -d /var/cron/tabs || mkdir -p /var/cron/tabs
                echo "30 * * * *    /usr/bin/ntpdate -b -s -u pool.ntp.org" >> /var/cron/tabs/root
        fi
fi
}

