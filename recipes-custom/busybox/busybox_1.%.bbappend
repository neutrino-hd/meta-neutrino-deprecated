FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DEPENDS += "libpam"

SRC_URI += " \
	file://neutrino-busybox.cfg \
	file://telnetd.busybox \
	file://hostname.script \
	file://telnet.service \
"
inherit systemd

SYSTEMD_SERVICE_${PN} = "telnet.service"

PACKAGES_prepend += "${PN}-telnetd \
"

FILES_${PN}-telnetd = " \
	/etc/telnetd.busybox \
	/lib/systemd \
"

RRECOMMENDS_${PN} += "${PN}-telnetd"

INITSCRIPT_PACKAGES += "${PN}-telnetd"

INITSCRIPT_NAME_${PN}-telnetd = "telnetd.busybox"
INITSCRIPT_PARAMS_${PN}-telnetd = "defaults"

do_install_append() {
	install -d ${D}/lib/systemd/system/multi-user.target.wants
	install -m 0755 ${WORKDIR}/telnetd.busybox ${D}${sysconfdir}/telnetd.busybox
	install -m 0644 ${WORKDIR}/telnet.service ${D}/lib/systemd/system/telnet.service
	ln -s ../telnet.service ${D}/lib/systemd/system/multi-user.target.wants/telnet.service
	if grep "CONFIG_TELNETD=y" ${B}/.config; then
		install -m 0755 ${WORKDIR}/telnetd.busybox ${D}${sysconfdir}/telnetd.${BPN}
	fi
	if grep "CONFIG_UDHCPC=y" ${B}/.config; then
		# the directory was created already before in do_install()
		install -m 0755 ${WORKDIR}/hostname.script ${D}${sysconfdir}/udhcpc.d/51hostname
	fi
}

pkg_prerm_${PN}-telnetd () {
#!/bin/sh
# do not stop telnetd on update, or uninstall is impossible
# while being logged in via telnet
exit 0
}

pkg_postinst_${PN}-telnetd() {
#!/bin/sh
if test "x$D" != "x"; then
	OPT="-r $D"
fi
if type update-rc.d >/dev/null 2>/dev/null; then
	update-rc.d $OPT telnetd.busybox defaults
	# "restart" as done by "update-rc.d -s" is deadly for existing connections
	test "x$D" = "x" && /etc/init.d/telnetd.busybox start
fi
exit
}
