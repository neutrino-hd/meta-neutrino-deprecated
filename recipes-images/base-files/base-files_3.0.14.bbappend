FILESEXTRAPATHS_prepend := "${THISDIR}/base-files:"

SRC_URI += "file://profile \
	    file://inputrc \
	    file://cam \
	    file://local.sh \
	    file://create_var.sh \
"

BASEFILESISSUEINSTALL = "do_custom_baseissueinstall"

do_custom_baseissueinstall() {
	do_install_basefilesissue
	install -m 644 ${WORKDIR}/issue*  ${D}${sysconfdir}
	printf " __  __         __         ___       __"			>> ${D}${sysconfdir}/issue
	printf " __  __         __         ___       __"			>> ${D}${sysconfdir}/issue.net
	printf "\n%s" ' \\ \\/ /__  ____/ /____    / _ \\___  / /____ __'	>> ${D}${sysconfdir}/issue
	printf "\n%s" ' \\ \\/ /__  ____/ /____    / _ \\___  / /____ __' 	>> ${D}${sysconfdir}/issue.net
	printf "\n%s" '  \\  / _ \\/ __/ __/ _ \\  / ___/ _ \\/  ´_/ // /' 	>> ${D}${sysconfdir}/issue
	printf "\n%s" '  \\  / _ \\/ __/ __/ _ \\  / ___/ _ \\/  ´_/ // /' 	>> ${D}${sysconfdir}/issue.net
	printf "\n%s" '  /_/\\___/\\__/\\__/\\___/ /_/   \\___/_/\\_\\\\_, /' 	>> ${D}${sysconfdir}/issue
	printf "\n%s" '  /_/\\___/\\__/\\__/\\___/ /_/   \\___/_/\\_\\\\_, /' 	>> ${D}${sysconfdir}/issue.net
	printf "\n%s" '                                       /___/'		>> ${D}${sysconfdir}/issue
	printf "\n%s" '                                       /___/'		>> ${D}${sysconfdir}/issue.net
	printf "\n\nNeutrino-HD image (based on Yocto Poky ${DISTRO_VERSION})" 	>> ${D}${sysconfdir}/issue
	printf "\n\nNeutrino-HD image (based on Yocto Poky ${DISTRO_VERSION}) " >> ${D}${sysconfdir}/issue.net
	echo -e "\n%s %m %r" 							>> ${D}${sysconfdir}/issue
	echo -e "\n%s %m %r" 							>> ${D}${sysconfdir}/issue.net
	echo -e "%d, %t" 							>> ${D}${sysconfdir}/issue
	echo -e "%d, %t" 							>> ${D}${sysconfdir}/issue.net
	printf "\\\n \\\l\n"							>> ${D}${sysconfdir}/issue
	echo >> ${D}${sysconfdir}/issue
	echo >> ${D}${sysconfdir}/issue.net
}

do_install_prepend_coolstream-hd2 () {
	install -d ${D}${sysconfdir}/init.d
	install -m 755 ${S}/cam ${D}${sysconfdir}/init.d/cam
	install -m 755 ${S}/local.sh ${D}${sysconfdir}/init.d/local.sh
	install -m 755 ${S}/create_var.sh ${D}${sysconfdir}/init.d/create_var.sh
	update-rc.d -r ${D} local.sh start 90 S .
	update-rc.d -r ${D} create_var.sh start 10 S .
}

do_install_prepend_coolstream-hd1 () {
	install -d ${D}${sysconfdir}/init.d
	install -m 755 ${S}/cam ${D}${sysconfdir}/init.d/cam
	update-rc.d -r ${D} cam start 99 S .
}

# links to get better compatibility for precompiled binaries on the nevis platform
do_install_append_coolstream-hd1 () {
	install -d ${D}${base_libdir} ${D}${libdir}
	ln -s ./libcrypto.so.1.0.0 ${D}${base_libdir}/libcrypto.so.0.9.8
	ln -s ./libssl.so.1.0.0 ${D}${libdir}/libssl.so.0.9.8
}

