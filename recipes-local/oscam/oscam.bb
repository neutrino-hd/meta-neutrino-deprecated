SUMMARY = "OSCam: Open Source Conditional Access Module"
HOMEPAGE = "http://www.streamboard.tv/oscam/"
LICENSE = "GPLv3"
LIC_FILES_CHKSUM = "file://COPYING;md5=d32239bcb673463ab874e80d47fae504"

DEPENDS = "libusb1 openssl virtual/stb-hal-libs"

SRC_URI = " \
	svn://www.streamboard.tv/svn/oscam;module=trunk;protocol=http \
	file://oscam.user \
	file://oscam.server_${MACHINE} \
	file://oscam.services \
	file://oscam.dvbapi \
	file://oscam.conf \
"

SRC_URI_append_coolstream-hd2 = " \
	file://CMakeLists.patch \
"

SRCREV = "${AUTOREV}"
PV = "1.20+svn${SRCPV}"

S = "${WORKDIR}/trunk"
	
INHIBIT_PACKAGE_STRIP = "1"

inherit cmake

do_configure_append_coolstream-hd2 () {
	if [ ${BOXTYPE} = "kronos" ];then
		sed -i "s|^#define MAX_COOL_DMX.*|#define MAX_COOL_DMX 3|" ${S}/module-dvbapi-coolapi.c
	fi
}

EXTRA_OECMAKE = " \
		 -DWEBIF=1 \
		 -DHAVEDVBAPI=1 \
		 -DUSE_LIBCRYPTO=1 \
		 -DUSE_LIBUSB=0 \
		 -DUSE_PCSC=0 \ 
		 -DUSE_STAPI=1 \
		 -DREADER_IRDETO=1 \
		 -DREADER_NAGRA=1 \
		 -DREADER_SECA=0 \
		 -DREADER_CRYPTOWORKS=0 \
		 -DREADER_CONAX=0 \
		 -DREADER_VIACCESS=0 \
		 -DREADER_VIDEOGUARD=0 \
		 -DMODULE_CAMD35=1 \
		 -DMODULE_GBOX=0 \
		 -DMODULE_CCCAM=1 \
		 -DMODULE_CCCSHARE=1 \
		 -DCARDREADER_SC8IN1=0 \
		 -DCARDREADER_SMARGO=0 \
"

EXTRA_OECMAKE_append_coolstream-hd1 += "-DOSCAM_SYSTEM_NAME=Coolstream \
"

EXTRA_OECMAKE_append_coolstream-hd2 += "-DOSCAM_SYSTEM_NAME=CST2 \
"

do_install () {
	install -d ${D}/etc/neutrino/config ${D}/etc/neutrino/bin
	install -D -m 755 ${WORKDIR}/build/oscam ${D}/etc/neutrino/bin/oscam
	install -D -m 644 ${WORKDIR}/oscam.* ${D}/etc/neutrino/config
	mv ${D}/etc/neutrino/config/oscam.server_${MACHINE} ${D}/etc/neutrino/config/oscam.server
}
