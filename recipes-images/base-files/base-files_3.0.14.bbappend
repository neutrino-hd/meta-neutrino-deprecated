FILESEXTRAPATHS_prepend := "${THISDIR}/base-files:"

SRC_URI += "file://profile \
	    file://inputrc \
	    file://local.sh \
	    file://stb_update.sh \
	    file://stb_update-hd1.sh \
	    file://cam.sh \
"

BASEFILESISSUEINSTALL = "do_custom_baseissueinstall"

do_custom_baseissueinstall() {
	do_install_basefilesissue
	install -m 644 ${WORKDIR}/issue*  ${D}${sysconfdir}
	printf " __  __         __         ___       __"				>> ${D}${sysconfdir}/issue
	printf " __  __         __         ___       __"				>> ${D}${sysconfdir}/issue.net
	printf "\n%s" ' \\ \\/ /__  ____/ /____    / _ \\___  / /____ __'		>> ${D}${sysconfdir}/issue
	printf "\n%s" ' \\ \\/ /__  ____/ /____    / _ \\___  / /____ __' 		>> ${D}${sysconfdir}/issue.net
	printf "\n%s" '  \\  / _ \\/ __/ __/ _ \\  / ___/ _ \\/  ´_/ // /' 		>> ${D}${sysconfdir}/issue
	printf "\n%s" '  \\  / _ \\/ __/ __/ _ \\  / ___/ _ \\/  ´_/ // /' 		>> ${D}${sysconfdir}/issue.net
	printf "\n%s" '  /_/\\___/\\__/\\__/\\___/ /_/   \\___/_/\\_\\\\_, /' 		>> ${D}${sysconfdir}/issue
	printf "\n%s" '  /_/\\___/\\__/\\__/\\___/ /_/   \\___/_/\\_\\\\_, /' 		>> ${D}${sysconfdir}/issue.net
	printf "\n%s" '                                       /___/'			>> ${D}${sysconfdir}/issue
	printf "\n%s" '                                       /___/'			>> ${D}${sysconfdir}/issue.net
	printf "\n\nNeutrino-HD image (based on Yocto ${DISTRO} ${DISTRO_VERSION})" 	>> ${D}${sysconfdir}/issue
	printf "\n\nNeutrino-HD image (based on Yocto ${DISTRO} ${DISTRO_VERSION}) " 	>> ${D}${sysconfdir}/issue.net
	echo "\n%s %m %r" 								>> ${D}${sysconfdir}/issue
	echo "\n%s %m %r" 								>> ${D}${sysconfdir}/issue.net
	echo "%d, %t" 									>> ${D}${sysconfdir}/issue
	echo "%d, %t" 									>> ${D}${sysconfdir}/issue.net
	printf "\\\n \\\l\n"								>> ${D}${sysconfdir}/issue
	echo >> ${D}${sysconfdir}/issue
	echo >> ${D}${sysconfdir}/issue.net
}

do_install_prepend_coolstream-hd2 () {
	install -d ${D}${sysconfdir}/init.d  ${D}${localstatedir}/update
	install -m 755 ${S}/local.sh ${D}${sysconfdir}/init.d/local.sh
	install -m 755 ${S}/stb_update.sh ${D}${sysconfdir}/init.d/bb_stb_update.sh
	install -m 755 ${S}/cam.sh ${D}${sysconfdir}/init.d/cam.sh
	update-rc.d -r ${D} local.sh start 40 S .
	update-rc.d -r ${D} bb_stb_update.sh start 03 S .
	update-rc.d -r ${D} cam.sh start 60 5 .
	touch ${D}${localstatedir}/update/.newimage
 	if [ ${CLEAN_ENV} = "yes" ];then
		touch ${D}${localstatedir}/update/.erase_env 
	fi
}

do_install_append_coolstream-hd1 () {
	install -d ${D}${base_libdir} ${D}${libdir} ${D}${localstatedir}/update ${D}${sysconfdir}/init.d
	install -m 755 ${S}/local.sh ${D}${sysconfdir}/init.d/local.sh
	install -m 755 ${S}/cam.sh ${D}${sysconfdir}/init.d/cam.sh
	update-rc.d -r ${D} local.sh start 40 S .
	update-rc.d -r ${D} cam.sh start 60 5 .
	# hack to get better compatibility for precompiled binaries on the nevis platform
	ln -s ./libcrypto.so.1.0.0 ${D}${base_libdir}/libcrypto.so.0.9.8
	ln -s ./libssl.so.1.0.0 ${D}${libdir}/libssl.so.0.9.8
	install -m 755 ${S}/stb_update-hd1.sh ${D}${sysconfdir}/init.d/bb_stb_update.sh
	update-rc.d -r ${D} bb_stb_update.sh start 03 S .
	if [ ${IMAGETYPE} = "tiny" ]; then
		sed -i "s|opkg $*|opkg --cache=/tmp --tmp-dir=/tmp $*|" ${D}${sysconfdir}/profile
	fi
}

# compatibility links for prebuild binaries that have been built with smelly old software
do_install_append_libc-uclibc () {
	ln -s ./librt.so.1 ${D}${base_libdir}/librt.so.0
	ln -s ./libc.so.1 ${D}${base_libdir}/libc.so.0
	ln -s ./libpthread.so.1 ${D}${base_libdir}/libpthread.so.0
	ln -s ./libcrypt.so.1 ${D}${base_libdir}/libcrypt.so.0
	ln -s ./libdl.so.1 ${D}${base_libdir}/libdl.so.0
}
