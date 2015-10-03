FILESEXTRAPATHS_prepend := "${THISDIR}/nfs-utils:"

SRC_URI_append += "file://volatiles.04_nfs"

SRC_URI_append_libc-uclibc += "file://sockaddr_h.patch"

do_install_append() {
	install -d ${D}${sysconfdir}/default/volatiles
	install -m 0644 ${WORKDIR}/volatiles.04_nfs ${D}${sysconfdir}/default/volatiles/04_nfs
}
