FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://0001-build_fix.patch \
		   file://0002-fix-freeze-when-unplugging-without_unmount.patch \
		   file://00-create-volatile.conf \
		   file://cs_drivers_kronos.conf \
		   file://cs_drivers_apollo.conf \
	  	   file://framebuffer.conf \
		   file://ifup.service \
"
PACKAGECONFIG_append += ""
PACKAGECONFIG_remove_libc-uclibc = "localed resolved"

do_install_append() {
	install -d ${D}/${sysconfdir}/modprobe.d
	if [ ${BOXTYPE} = "kronos" ];then
		install -m 644 ${WORKDIR}/cs_drivers_kronos.conf ${D}${sysconfdir}/modules-load.d/cs_drivers.conf
	elif [ ${BOXTYPE} = "apollo" ];then
		install -m 644 ${WORKDIR}/cs_drivers_apollo.conf ${D}${sysconfdir}/modules-load.d/cs_drivers.conf	
	fi
	install -m 644 ${WORKDIR}/framebuffer.conf ${D}${sysconfdir}/modprobe.d/
	install -m 644 ${WORKDIR}/ifup.service  ${D}/lib/systemd/system/ifup.service
	ln -s /lib/systemd/system/ifup.service ${D}/etc/systemd/system/multi-user.target.wants/ifup.service
	sed -i "s|slave|shared|" ${D}/lib/systemd/system/systemd-udevd.service
	rm ${D}/etc/resolv.conf && touch ${D}/etc/resolv.conf
}



FILES_${PN}_append += "\
	/etc \
"
