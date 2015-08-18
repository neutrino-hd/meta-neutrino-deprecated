FILESEXTRAPATHS_prepend := "${THISDIR}/base-files:"

SRC_URI += "file://profile \
	    file://inputrc \
	    file://local.sh \
	    file://create_var.sh \
	    file://stb_update.sh \
	    file://create_etc.sh \
	    file://update_etc.sh \
	    file://cam.sh \
"

BASEFILESISSUEINSTALL = "do_custom_baseissueinstall"

INITSCRIPT_NAME = "update_etc"

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
	echo -e "\n%s %m %r" 								>> ${D}${sysconfdir}/issue
	echo -e "\n%s %m %r" 								>> ${D}${sysconfdir}/issue.net
	echo -e "%d, %t" 								>> ${D}${sysconfdir}/issue
	echo -e "%d, %t" 								>> ${D}${sysconfdir}/issue.net
	printf "\\\n \\\l\n"								>> ${D}${sysconfdir}/issue
	echo >> ${D}${sysconfdir}/issue
	echo >> ${D}${sysconfdir}/issue.net
}


do_configure_prepend () {
	sed -i "s|GIT_USER|${GIT_USER}|" ${WORKDIR}/update_etc.sh
	sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/update_etc.sh
	sed -i "s|GIT_URL|${GIT_URL}|" ${WORKDIR}/update_etc.sh
	sed -i "s|GIT_USER|${GIT_USER}|" ${WORKDIR}/create_etc.sh
	sed -i "s|MAIL|${MAIL}|" ${WORKDIR}/create_etc.sh
	sed -i "s|GIT_URL|${GIT_URL}|" ${WORKDIR}/create_etc.sh
	if [ ${DISTRO} = "coolstream-hd1_flash" ];then
		sed -i "s|nano|vi|" ${WORKDIR}/create_etc.sh
		sed -i "s|nano|vi|" ${WORKDIR}/update_etc.sh
	fi
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
	if [ ${USE_VAR} = "yes" ];then
		install -d  ${D}${localstatedir}${sysconfdir}/network ${D}${localstatedir}/bin
		install -m 755 ${S}/create_var.sh ${D}${sysconfdir}/init.d/create_var.sh
		update-rc.d -r ${D} create_var.sh start 03 S .
			if [ ${CLEAN_VAR} == "yes" ];then
				touch ${D}${localstatedir}/update/.erase_var
			fi
	elif [ ${USE_ETC} = "yes" ];then
		install -m 755 ${S}/update_etc.sh ${D}${sysconfdir}/init.d/update_etc.sh
		install -m 755 ${S}/create_etc.sh ${D}${sysconfdir}/init.d/create_etc.sh
		update-rc.d -r ${D} update_etc.sh start 08 5 .
	fi
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
	if [ ${USE_ETC} = "yes" ];then
		install -m 755 ${S}/update_etc.sh ${D}${sysconfdir}/init.d/update_etc.sh
		install -m 755 ${S}/create_etc.sh ${D}${sysconfdir}/init.d/create_etc.sh
		update-rc.d -r ${D} update_etc.sh start 08 5 .		
	fi
	touch ${D}${localstatedir}/update/.newimage
}
