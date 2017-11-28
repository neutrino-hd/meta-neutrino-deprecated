SUMMARY = "C++ parsing library for Service Information (SI) in DVB systems"
AUTHOR = "Andreas Oberritter"
SECTION = "libs/multimedia"
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://COPYING;md5=a6f89e2100d9b6cdffcea4f398e37343"
PR = "r3"

SRC_URI = " \
           git://git.opendreambox.org/git/obi/libdvbsi++.git \
           file://libdvbsi++-fix-unaligned-access-on-SuperH.patch \
           file://libdvbsi++-src-time_date_section.cpp-fix-sectionLength-check.patch \
	   file://libdvbsi++-content_identifier_descriptor.patch \
"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

inherit autotools pkgconfig

CPPFLAGS_libc-uclibc = "-D_GLIBCXX_USE_CXX11_ABI=0"

