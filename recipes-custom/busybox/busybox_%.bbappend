FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
DEPENDS += "libpam"

SRC_URI += " \
	file://neutrino-busybox.cfg \
	file://telnetd.busybox \
	file://hostname.script \
	file://inetd.conf \
	file://simple.script \
	file://resolv.conf \
"

PACKAGES_prepend += "${PN}-inetd \
		     ${PN}-telnetd \
"

FILES_${PN}-inetd = " \
	/etc/init.d/inetd.busybox \
	/etc/inetd.conf \
"
FILES_${PN}-telnetd = " \
	/etc/init.d/telnetd.busybox \
"

RRECOMMENDS_${PN} += "${PN}-inetd ${PN}-telnetd"

INITSCRIPT_PACKAGES += "${PN}-inetd ${PN}-telnetd"

INITSCRIPT_NAME_${PN}-inetd = "inetd.busybox"
INITSCRIPT_NAME_${PN}-telnetd = "telnetd.busybox"
INITSCRIPT_PARAMS_${PN}-inetd = "defaults"
INITSCRIPT_PARAMS_${PN}-telnetd = "defaults"

do_install_append() {
	if grep "CONFIG_TELNETD=y" ${B}/.config; then
		install -m 0755 ${WORKDIR}/telnetd.busybox ${D}${sysconfdir}/init.d/telnetd.${BPN}
	fi
	if grep "CONFIG_UDHCPC=y" ${B}/.config; then
		# the directory was created already before in do_install()
		install -m 0755 ${WORKDIR}/hostname.script ${D}${sysconfdir}/udhcpc.d/51hostname
	fi
	install -m 0644 ${WORKDIR}/resolv.conf ${D}/etc/resolv.conf
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
