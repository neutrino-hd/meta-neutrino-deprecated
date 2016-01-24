require ffmpeg.inc

SRCREV = "${AUTOREV}"
PV = "2.6"
SRC_URI = "git://git.slknet.de/git/cst-public-libraries-ffmpeg.git;protocol=git;branch=ffmpeg-head \
	   file://0001-switch-HDS-to-roxml_old.patch \
"

LIC_FILES_CHKSUM = " \
	file://COPYING.GPLv2;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
	file://COPYING.GPLv3;md5=d32239bcb673463ab874e80d47fae504 \
	file://COPYING.LGPLv2.1;md5=bd7a443320af8c812e4c18d1b79df004 \
	file://COPYING.LGPLv3;md5=e6a600fd5e1d9cbde2d983680233ad02 \
"

S = "${WORKDIR}/git"

EXTRA_OECONF += " \
	--enable-postproc \
"

PROVIDES = "ffmpeg_${PV}"
