FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://00-create-volatile.conf \
		   file://cs_drivers_kronos.conf \
		   file://cs_drivers_apollo.conf \
	  	   file://framebuffer.conf \
"

SRC_URI_append_libc-uclibc += "file://0001-build_fix.patch \
"

PACKAGECONFIG_append += ""
PACKAGECONFIG_remove_libc-uclibc = " resolved hibernate localed "
 
inherit autotools-brokensep

CFLAGS_append += "-DHAVE_NSS_H=0 -DSD_BOOT_LOG_TPM=0"

do_install_append() {
	install -d ${D}/${sysconfdir}/modprobe.d
	if [ ${BOXTYPE} = "kronos" ];then
		install -m 644 ${WORKDIR}/cs_drivers_kronos.conf ${D}${sysconfdir}/modules-load.d/cs_drivers.conf
	elif [ ${BOXTYPE} = "apollo" ];then
		install -m 644 ${WORKDIR}/cs_drivers_apollo.conf ${D}${sysconfdir}/modules-load.d/cs_drivers.conf	
	fi
	install -m 644 ${WORKDIR}/framebuffer.conf ${D}${sysconfdir}/modprobe.d/
	sed -i "s|slave|shared|" ${D}/lib/systemd/system/systemd-udevd.service
	rm ${D}/etc/resolv.conf && touch ${D}/etc/resolv.conf
}



FILES_${PN}_append += "\
	/etc \
"

pkg_postinst_udev-hwdb () {
		udevadm hwdb --update
}
