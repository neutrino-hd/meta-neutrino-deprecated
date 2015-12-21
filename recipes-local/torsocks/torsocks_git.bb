SUMMARY = "torsocks"
DESCRIPTION = "allow non SOCKS aware applications (e.g telnet, ssh, ftp etc) to use SOCKS without any modification."
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/dgoulet/torsocks/;protocol=git;branch=master"
PR = "1"

SRCREV = "${AUTOREV}"
PV = "${SRCPV}"

S = "${WORKDIR}/git"

inherit autotools


