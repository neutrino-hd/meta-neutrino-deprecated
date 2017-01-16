SUMMARY = "fdk-aac"
DESCRIPTION = "A standalone library of the Fraunhofer FDK AAC code from Android"
HOMEPAGE = "https://github.com/mstorsjo/fdk-aac"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://NOTICE;md5=087ae5edf3094fbebf2e44334fa2155c"

DEPENDS = ""

SRCREV ?= "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

SRC_URI = " \
    git://github.com/mstorsjo/fdk-aac;protocol=https \
"

S = "${WORKDIR}/git"

inherit autotools
