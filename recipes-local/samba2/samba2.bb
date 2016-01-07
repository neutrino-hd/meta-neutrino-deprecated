DESCRIPTION = "Samba 2 binaries precompiled for hd1 "
LICENSE = "GPL-3.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"
HOMEPAGE = "www.samba.org"
DEPENDS = ""
COMPATIBLE_MACHINE = "coolstream-hd1"
PV = "2.xx"
PR = "1"


SRC_URI = "file://smbd \
	   file://nmbd \
	   file://smb.conf \
	   file://samba \
"

inherit update-rc.d

CONFFILES_${PN} = "${sysconfdir}/smb.conf"

INITSCRIPT_NAME = "samba"

S = "${WORKDIR}/"

do_install () {
	install -d ${D}${sysconfdir}/samba/private ${D}${sysconfdir}/init.d ${D}${sbindir}
	install -m 644 ${S}smbd ${D}${sbindir}
	install -m 644 ${S}nmbd ${D}${sbindir}
	install -m 644 ${S}smb.conf ${D}${sysconfdir}/smb.conf
	install -m 644 ${S}samba ${D}${sysconfdir}/init.d/samba
}
