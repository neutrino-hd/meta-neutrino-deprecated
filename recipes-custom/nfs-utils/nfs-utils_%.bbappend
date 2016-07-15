FILESEXTRAPATHS_prepend := "${THISDIR}/nfs-utils:"

SRC_URI_append += "file://volatiles.04_nfs"

SRC_URI_append_libc-uclibc += "file://sockaddr_h.patch"

do_install_append () {
	install -d ${D}${sysconfdir}/default/volatiles ${D}${systemd_unitdir}/system/multi-user.target.wants/
	install -m 0644 ${WORKDIR}/volatiles.04_nfs ${D}${sysconfdir}/default/volatiles/04_nfs
	ln -sf ${systemd_unitdir}/system/nfs-server.service ${D}${systemd_unitdir}/system/multi-user.target.wants/nfs-server.service
	ln -sf ${systemd_unitdir}/system/nfs-mountd.service ${D}${systemd_unitdir}/system/multi-user.target.wants/nfs-mountd.service
	ln -sf ${systemd_unitdir}/system/nfs-statd.service ${D}${systemd_unitdir}/system/multi-user.target.wants/nfs-statd.service
}

