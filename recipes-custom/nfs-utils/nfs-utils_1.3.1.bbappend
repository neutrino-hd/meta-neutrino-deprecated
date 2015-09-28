FILESEXTRAPATHS_prepend := "${THISDIR}/nfs-utils:"

SRC_URI_append_libc-uclibc += "file://sockaddr_h.patch \
			       file://volatiles.04_nfs \
"


do_install_append() {
	install -d ${D}${sysconfdir}/default/volatiles
	install -m 0644 ${WORKDIR}/volatiles.04_nfs ${D}${sysconfdir}/default/volatiles/04_nfs
}
