SUMMARY = "RTMP Dump"
DESCRIPTION = "rtmpdump is a toolkit for RTMP streams. All forms of RTMP are \
supported, including rtmp://, rtmpt://, rtmpe://, rtmpte://, and rtmps://."
HOMEPAGE = "http://rtmpdump.mplayerhq.hu/"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=751419260aa954499f7abaabaa882bbe"

DEPENDS = "openssl zlib"

SRCREV ?= "${AUTOREV}"
PV = "${SRCPV}"
PR = "1"

SRC_URI = " \
    git://git.ffmpeg.org/rtmpdump \
"

S = "${WORKDIR}/git"

inherit autotools-brokensep

EXTRA_OEMAKE = " \
    CC='${CC} -Wl,--hash-style=gnu -Os -Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib' \
    SYS=posix INC=-I=/usr/include DESTDIR=${D} \
    prefix=${prefix} libdir=${libdir} incdir=${includedir}/librtmp bindir=${bindir} mandir=${mandir}"

do_install_prepend() {
	install -d ${D}/usr/lib
}
