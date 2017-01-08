SUMMARY = "OSEmu: emu for oscam/doscam"
HOMEPAGE = "https://github.com/nautilus7/OSEmu"
LICENSE = "GPL-3.0"
PRIORITY = "optional"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI[md5sum] = "c93cd8e3417a6432396c49a488edd14a"
SRC_URI[sha256sum] = "5dd2e1bb7a82798a325d947d7fd77f383e47c68d2582a0953020e3bc57191039"

DEPENDS = ""

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"
PR = "r4"

SRC_URI = " \
	git://github.com/nautilus7/OSEmu.git \
	file://0002-OSEmu.c-search-keyfile-in-etc-neutrino-config.patch \
"

INHIBIT_PACKAGE_STRIP = "1"

S = "${WORKDIR}/git"

inherit autotools-brokensep

do_install() {
	install -d ${D}${sysconfdir}/neutrino/bin
	install -m 755 ${S}/OSEmu ${D}${sysconfdir}/neutrino/bin/osemu
}

