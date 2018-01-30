SUMMARY = "Neutrino HD"
DESCRIPTION = "CST Neutrino HD for Coolstream Settop Boxes."
HOMEPAGE = "https://github.com/tuxbox-neutrino"
SECTION = "libs"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING.GPL;md5=751419260aa954499f7abaabaa882bbe"

inherit autotools pkgconfig

DEPENDS += " \
	curl \
	ffmpeg \
	freetype \
	gettext \
	giflib \
	libpng \
	libbluray \
	libdvbsi++ \
	jpeg \
	libsigc++ \
	libroxml \
	lua \
	luaposix \
	openthreads \
	pugixml \
	virtual/stb-hal-libs \
	virtual/libiconv \
"

RCONFLICTS_${PN} = "neutrino-mp"

SRCREV ?= "${AUTOREV}"
PV = "${SRCPV}"
PR = "6"

SRC_URI = "git://github.com/tuxbox-neutrino/gui-neutrino.git;protocol=http;branch=master \
	   file://neutrino.init \
	   file://timezone.xml \
	   file://custom-poweroff.init \
	   file://pre-wlan0.sh \
	   file://post-wlan0.sh \
	   file://mount.mdev \
	   file://COPYING.GPL \
	   file://0008-rcsim.c-fix-eventdev-for-yocto.patch \
	   file://0010-nhttpd-adjust-some-paths.patch \
	   file://workaround_hdd_format.patch \
	   file://icons.tar.gz \
	   file://etc.tar.gz \
"

S = "${WORKDIR}/git"

include neutrino-hd.inc

do_configure_prepend() {
	INSTALL="`which install` -p"
	export INSTALL
	ln -sf ${B}/src/gui/version.h ${S}/src/gui/
	sed -i "s|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|${YT_DEV_KEY}|" ${S}/src/neutrino.cpp
	sed -i "s|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|${TMDB_DEV_KEY}|" ${S}/src/neutrino.cpp
	sed -i "s|XXXXXXXXXXXXXXXX|${SHOUTCAST_DEV_KEY}|" ${S}/src/neutrino.cpp
}

do_compile () {
	# unset CFLAGS CXXFLAGS LDFLAGS
	oe_runmake CFLAGS="${N_CFLAGS}" CXXFLAGS="${N_CXXFLAGS}" LDFLAGS="${N_LDFLAGS}"
}


do_install_prepend () {
	install -d ${D}/${sysconfdir}/init.d ${D}${sysconfdir}/network
	install -m 755 ${WORKDIR}/neutrino.init ${D}${sysconfdir}/init.d/neutrino
	install -m 755 ${WORKDIR}/custom-poweroff.init ${D}${sysconfdir}/init.d/custom-poweroff
	install -m 755 ${WORKDIR}/pre-wlan0.sh ${D}${sysconfdir}/network/
	install -m 755 ${WORKDIR}/post-wlan0.sh ${D}${sysconfdir}/network/
	install -m 644 ${WORKDIR}/timezone.xml ${D}${sysconfdir}/timezone.xml
	install -d ${D}${localstatedir}/cache
	install -d ${D}${localstatedir}/tuxbox
	install -d ${D}/lib/mdev/fs
	install -m 755 ${WORKDIR}/mount.mdev ${D}/lib/mdev/fs/mount
	echo "creator=${CREATOR}"             >> ${D}/.version 
	echo "imagename=yocto ${DISTRO}"             >> ${D}/.version 
	echo "homepage=${HOMEPAGE}"              >> ${D}/.version
        echo "version=${DISTRO_VERSION_NUMBER}"   >> ${D}/.version
	HASH=$(cd ${S} && echo `git rev-parse --abbrev-ref HEAD` `git describe --always --tags --dirty`)
	if [ ! -z ${RELEASE_TEXT_LOCATION_HOST} ];then 
		echo "${IMAGE_LOCATION} ${RELEASE_STATE}${DISTRO_VERSION_NUMBER_MAJOR}${DISTRO_VERSION_NUMBER_MINOR}"0"`date +%Y%m%d%H%M` MD5 ${HASH} ${DISTRO_VERSION}" > ${RELEASE_TEXT_LOCATION_HOST}
	fi
	update-rc.d -r ${D} custom-poweroff start 89 0 .
	update-rc.d -r ${D} neutrino start 99 5 . stop 20 0 1 2 3 4 6 .


}

do_install_append() {
	install -d ${D}/share ${D}/${sysconfdir}/neutrino/bin ${D}/var/tuxbox/plugins/webtv
	ln -s ${datadir}/tuxbox ${D}/share/
	ln -s ${datadir}/fonts  ${D}/share/
	cp -rf ${WORKDIR}/icons ${D}/usr/share/tuxbox/neutrino/
	cp -rf ${WORKDIR}/etc ${D}/etc/neutrino/
	if [ ! -z ${RELEASE_TEXT_LOCATION} ];then
		echo "${RELEASE_TEXT_LOCATION}" > ${D}/etc/update.urls
	fi
}

FILES_${PN} += "\
	/.version \
	/etc \
	/lib/mdev/fs \
	/usr/share \
	/usr/share/tuxbox \
	/usr/share/iso-codes \
	/usr/share/fonts \
	/usr/share/tuxbox/neutrino \
	/usr/share/iso-codes \
	/usr/share/fonts \
	/share/fonts \
	/share/tuxbox \
	/var/cache \
	/var/httpd/styles \
"

pkg_preinst_${PN} () {
	if [ -f /etc/neutrino/config/zapit/frontend.conf ];then
		mv /etc/neutrino/config/zapit/frontend.conf /etc/neutrino/config/zapit/frontend.conf.orig
	fi
}

pkg_postinst_${PN} () {
	update-alternatives --install /bin/backup.sh backup.sh /usr/bin/backup.sh 100
	update-alternatives --install /bin/install.sh install.sh /usr/bin/install.sh 100
	update-alternatives --install /bin/restore.sh restore.sh /usr/bin/restore.sh 100
	# pic2m2v is only available on platforms that use "real" libstb-hal
	if which pic2m2v >/dev/null 2>&1; then
		# neutrino icon path
		I=/usr/share/tuxbox/neutrino/icons
		pic2m2v $I/mp3.jpg $I/radiomode.jpg $I/scan.jpg $I/shutdown.jpg $I/start.jpg
	fi
	if [ -f /etc/neutrino/config/zapit/frontend.conf.orig ];then 
		mv /etc/neutrino/config/zapit/frontend.conf.orig /etc/neutrino/config/zapit/frontend.conf
	fi
}


