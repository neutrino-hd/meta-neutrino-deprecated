FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DESCRIPTION = "Mediathek Lua plugin"
MAINTAINER = "Michael Liebmann"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
HOMEPAGE = "https://slknet.de/"
DEPENDS = "lua"
RDEPENDS_${PN} = "lua-json luaposix"

PV = "0.12"

SRC_URI = "git://github.com/neutrino-mediathek/mediathek.git;branch=master;protocol=https \
		   file://0001-Makefile-add-dummy-clean-target.patch \
"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PKGV = "${GITPKGVTAG}"

S = "${WORKDIR}/git"

do_install () {
	install -d ${D}/etc/neutrino/plugins ${D}/usr/share
	cp -rf ${S}/plugins/* ${D}/etc/neutrino/plugins/
	cp -rf ${S}/share ${D}/usr/
}

FILES_${PN} += "/usr/share/*"

