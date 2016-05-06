FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://0001-build_fix.patch \
		   file://00-create-volatile.conf \
		   file://cs_drivers.conf \
	  	   file://framebuffer.conf \
		   file://ifup.service \
"

do_install_append() {
	install -d ${D}/${sysconfdir}/modprobe.d
	install -m 644 ${WORKDIR}/cs_drivers.conf ${D}${sysconfdir}/modules-load.d/
	install -m 644 ${WORKDIR}/framebuffer.conf ${D}${sysconfdir}/modprobe.d/
	install -m 644 ${WORKDIR}/ifup.service  ${D}/lib/systemd/system/ifup.service
	ln -s /lib/systemd/system/ifup.service ${D}/etc/systemd/system/multi-user.target.wants/ifup.service
}

FILES_${PN}_append += "\
	/etc \
"
