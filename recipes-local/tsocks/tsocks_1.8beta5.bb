SUMMARY = "tsocks used for proxy"
DESCRIPTION = "allow non SOCKS aware applications (e.g telnet, ssh, ftp etc) to use SOCKS without any modification."
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "${SOURCEFORGE_MIRROR}/project/tsocks/tsocks/1.8%20beta%205/tsocks-1.8beta5.tar.gz"
PR = "1"

SRC_URI[md5sum] = "51caefd77e5d440d0bbd6443db4fc0f8"
SRC_URI[sha256sum] = "849d7ef5af80d03e76cc05ed9fb8fa2bcc2b724b51ebfd1b6be11c7863f5b347"

S = "${WORKDIR}/tsocks-1.8"

do_configure () {
echo "workdir ${WORKDIR}"
  ./configure --prefix=${prefix}
}
do_compile () {
  make
}
do_install () {
  oe_runmake install DESTDIR=${D}
}

