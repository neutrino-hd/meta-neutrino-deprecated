require ffmpeg.inc

SRC_URI = "http://www.ffmpeg.org/releases/ffmpeg-2.3.3.tar.bz2"

SRC_URI[md5sum] = "72361d3b8717b6db3ad2b9da8df7af5e"
SRC_URI[sha256sum] = "bb4c0d10a24e08fe67292690a1b4d4ded04f5c4c388f0656c98940ab0c606446"

LIC_FILES_CHKSUM = " \
	file://COPYING.GPLv2;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
	file://COPYING.GPLv3;md5=d32239bcb673463ab874e80d47fae504 \
	file://COPYING.LGPLv2.1;md5=bd7a443320af8c812e4c18d1b79df004 \
	file://COPYING.LGPLv3;md5=e6a600fd5e1d9cbde2d983680233ad02 \
"

EXTRA_OECONF += " \
	--enable-postproc \
"

PROVIDES = "ffmpeg_${PV}"
