do_install_prepend() {
		sed -i "s|/usr/sbin|/usr/bin|" ${S}/examples/logrotate.cron
}
