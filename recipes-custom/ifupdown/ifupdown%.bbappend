FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://interfaces \
				   file://networking.service \
"

do_install_append() {
	install -d ${D}${systemd_unitdir}/system/multi-user.target.wants/ ${D}${sysconfdir}/network
	install -m0644 ${WORKDIR}/interfaces ${D}${sysconfdir}/network/interfaces
	install -m0644 ${WORKDIR}/networking.service ${D}${systemd_unitdir}/system/networking.service
	ln -sf ${systemd_unitdir}/system/networking.service ${D}${systemd_unitdir}/system/multi-user.target.wants/networking.service 
}

FILES_${PN}_append += "lib/systemd"