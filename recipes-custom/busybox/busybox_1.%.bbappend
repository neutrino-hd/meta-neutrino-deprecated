FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DEPENDS += "libpam"

SRC_URI_append += " \
	file://neutrino-busybox.cfg \
	file://telnetd.busybox \
	file://hostname.script \
	file://telnet.service \
	file://udhcpc.service \
"

inherit systemd

SYSTEMD_SERVICE_${PN}-syslog = ""
SYSTEMD_SERVICE_${PN} = "telnet.service"
SYSTEMD_SERVICE_${PN}-udhcpd = "udhcpc.service"

FILES_${PN}-syslog_remove = "${sysconfdir}/init.d/syslog* ${sysconfdir}/syslog-startup.conf* ${sysconfdir}/syslog.conf* ${systemd_unitdir}/system/syslog.service ${sysconfdir}/default/busybox-syslog"

FILES_${PN}-telnetd = " \
	/etc/telnetd.busybox \
	/lib/systemd \
"

RRECOMMENDS_${PN} += "${PN}-telnetd"

INITSCRIPT_PACKAGES += "${PN}-telnetd"
INITSCRIPT_NAME_${PN}-telnetd = "telnetd.busybox"
INITSCRIPT_PARAMS_${PN}-telnetd = "defaults"

PACKAGES_append += "${PN}-telnetd"

do_install_append() {
	install -d ${D}/lib/systemd/system/multi-user.target.wants
	install -m 0755 ${WORKDIR}/telnetd.busybox ${D}${sysconfdir}/telnetd.busybox
	install -m 0644 ${WORKDIR}/telnet.service ${D}/lib/systemd/system/telnet.service
	install -m 0644 ${WORKDIR}/udhcpc.service ${D}/lib/systemd/system/udhcpc.service
	ln -s ../telnet.service ${D}/lib/systemd/system/multi-user.target.wants/telnet.service
	ln -s ../udhcpc.service ${D}/lib/systemd/system/multi-user.target.wants/udhcpc.service
	if grep "CONFIG_TELNETD=y" ${B}/.config; then
		install -m 0755 ${WORKDIR}/telnetd.busybox ${D}${sysconfdir}/telnetd.${BPN}
	fi
	if grep "CONFIG_UDHCPC=y" ${B}/.config; then
		# the directory was created already before in do_install()
		install -m 0755 ${WORKDIR}/hostname.script ${D}${sysconfdir}/udhcpc.d/51hostname
	fi
}

ALTERNATIVE_${PN}-syslog = ""
ALTERNATIVE_LINK_NAME[syslog-conf] = ""

pkg_prerm_${PN}-telnetd () {
#!/bin/sh
# do not stop telnetd on update, or uninstall is impossible
# while being logged in via telnet
exit 0
}

