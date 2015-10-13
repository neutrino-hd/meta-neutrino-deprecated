SUMMARY = "Neutrino HD"
DESCRIPTION = "CST Neutrino HD for Coolstream Settop Boxes."
HOMEPAGE = "http://git.coolstreamtech.de"
SECTION = "libs"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/COPYING.GPL;md5=751419260aa954499f7abaabaa882bbe"

inherit autotools pkgconfig update-rc.d

DEPENDS += " \
	curl \
	ffmpeg \
	flac \
	freetype \
	freetype-native \
	gettext \
	giflib \
	libbluray \
	libdvbsi++ \
	libid3tag \
	libjpeg-turbo \
	libmad \
	libpng \
	libsigc++ \
	lua5.2 \
	luaposix \
	openssl \
	openthreads \
	pugixml \
	tremor \
	virtual/stb-hal-libs \
	virtual/libiconv \
"

RCONFLICTS_${PN} = "neutrino-mp"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "4"

SRC_URI = "git://git.slknet.de/git/cst-public-gui-neutrino.git;branch=cst-next \
	file://neutrino.init \
	file://timezone.xml \
	file://custom-poweroff.init \
	file://pre-wlan0.sh \
	file://post-wlan0.sh \
	file://mount.mdev \
	file://COPYING.GPL \
	file://0001-configure_fix.patch \
	file://0002-write_nameserver_into_interfaces.patch \
	file://0007-set-image-version.patch \
	file://0008-rcsim.c-fix-eventdev-for-yocto.patch \
	file://0009-src-nhttpd-tuxboxapi-controlapi.cpp-fix-eventdev-for.patch \
	file://0010-nhttpd-adjust-some-paths.patch \
	file://0011-opkg_manager.cpp-newer-versions-of-opkg-are-using-op.patch \
	file://0012-import-proper-working-format-device-function.patch \
	file://0013-disable-network_services-menu.patch \
"

SRC_URI_append_coolstream-hd1 = " \
	file://0005-remove-unneeded-mp3.jpg-files.patch;apply=yes \
"

SRC_URI_append_libc-glibc = "file://0006-Makefile.am-we-don-t-need-liconv-for-glibc.patch\
"

S = "${WORKDIR}/git"

INITSCRIPT_PACKAGES   = "${PN}"
INITSCRIPT_NAME_${PN} = "neutrino"
INITSCRIPT_PARAMS_${PN} = "start 99 5 . stop 20 0 1 2 3 4 6 ."

include neutrino-hd.inc

do_configure_prepend() {
	INSTALL="`which install` -p"
	export INSTALL
	export DVB_API_VERSION=5
	ln -sf ${WORKDIR}/build/src/gui/version.h ${S}/src/gui/
	sed -i "s|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|${YT_DEV_KEY}|" ${S}/src/neutrino.cpp
}

do_compile () {
	# unset CFLAGS CXXFLAGS LDFLAGS
	oe_runmake CFLAGS="${N_CFLAGS}" CXXFLAGS="${N_CXXFLAGS}" LDFLAGS="${N_LDFLAGS}"
}


do_install_prepend () {
# change number to force rebuild "1"
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
	echo "version=${DISTRO_VERSION}  `date +%Y-%m-%d` `date +%H:%M`"    > ${D}/.version 
	echo "creator=${CREATOR}"             >> ${D}/.version 
	echo "imagename=Neutrino-HD"             >> ${D}/.version 
	echo "homepage=${HOMEPAGE}"              >> ${D}/.version 
	update-rc.d -r ${D} custom-poweroff start 89 0 .
}

do_install_append () {
	install -d ${D}/${sysconfdir}/neutrino/bin
}

# compatibility with binaries hand-built with --prefix=
do_install_append() {
	install -d ${D}/share
	ln -s ${datadir}/tuxbox ${D}/share/
	ln -s ${datadir}/fonts  ${D}/share/
	ln -s ${sysconfdir}/neutrino/config ${D}${localstatedir}/tuxbox/config
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
	/var/tuxbox/plugins \
	/var/tuxbox/config \
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

