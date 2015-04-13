do_install_append () {
	echo "nameserver 8.8.8.8" > ${D}${sysconfdir}/resolvconf/resolv.conf.d/base
}

