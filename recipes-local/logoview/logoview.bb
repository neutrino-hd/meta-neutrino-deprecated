SUMMARY = "logoview - für CST nevis / apollo"
HOMEPAGE = "https://github.com/coolstreamtech/cst-public-plugins-logoview"
LICENSE = "GPL-2.0"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/coolstreamtech/cst-public-plugins-logoview.git;protocol=http \
	   file://logoview \
"

DEPENDS = "libjpeg-turbo"
SRCREV ?= "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

S = "${WORKDIR}/git"

INITSCRIPT_NAME = "logoview"

inherit update-rc.d

do_compile() { 
}

do_install_coolstream-hd1() {
	install -d ${D}/${bindir} ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/bin/logoview.nevis ${D}${bindir}/logoview
	install -m 755 ${WORKDIR}/logoview ${D}${sysconfdir}/init.d/logoview
}

do_install_coolstream-hd2() {
	install -d ${D}/${bindir} ${D}${sysconfdir}/init.d
	install -m 0755 ${S}/bin/logoview.apollo ${D}${bindir}/logoview
	install -m 755 ${WORKDIR}/logoview ${D}${sysconfdir}/init.d/logoview
}

FILES_${PN} = "/etc/init.d \
	       /usr/bin \
"

SRC_URI[md5sum] = "17e6a3996de2942629dce65db1a701c5"
SRC_URI[sha256sum] = "fbe10d46f61d769f7d92a296102e4e2bd3ee16130f11c5b10a1aae590ea1f5ca"


INSANE_SKIP_${PN}_append += "ldflags already-stripped file-rdeps"
