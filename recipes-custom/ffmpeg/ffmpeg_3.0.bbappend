FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

DEPENDS_append += "libroxml rtmpdump openssl virtual/libiconv"

SRC_URI_append += " \
		   file://0001-Revert-lavc-Switch-bitrate-to-64bit-unless-compatibi.patch \
		   file://0002-add-HDS-ro_new.patch \
"

PACKAGECONFIG ??= "avdevice avfilter bzlib gpl lzma libroxml librtmp libvorbis openssl theora x264 ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'x11 xv', '', d)}"
PACKAGECONFIG[librtmp] = "--enable-librtmp,--disable-librtmp,rtmpdump"
PACKAGECONFIG[libroxml] = "--enable-libroxml,--disable-libroxml,libroxml"

EXTRA_OECONF_append = " \
	--enable-ffserver \
	--enable-ffplay \
	--disable-runtime-cpudetect \
	--disable-neon \
	--disable-decoders \
	--enable-decoder=dca \
	--enable-decoder=dvdsub \
	--enable-decoder=dvbsub \
	--enable-decoder=text \
	--enable-decoder=srt \
	--enable-decoder=subrip \
	--enable-decoder=subviewer \
	--enable-decoder=subviewer1 \
	--enable-decoder=xsub \
	--enable-decoder=pgssub \
	--enable-decoder=movtext \
	--enable-decoder=mp3 \
	--enable-decoder=flac \
	--enable-decoder=aac \
	--enable-decoder=mjpeg \
	--enable-decoder=pcm_s16le \
	--enable-decoder=pcm_s16le_planar \
	--disable-parsers \
	--enable-parser=aac \
	--enable-parser=aac_latm \
	--enable-parser=ac3 \
	--enable-parser=dca \
	--enable-parser=mjpeg \
	--enable-parser=mpeg4video \
	--enable-parser=mpegvideo \
	--enable-parser=mpegaudio \
	--enable-parser=h264 \
	--enable-parser=vc1 \
	--enable-parser=dvdsub \
	--enable-parser=dvbsub \
	--enable-parser=flac \
	--enable-parser=vorbis \
	--disable-demuxers \
	--enable-demuxer=aac \
	--enable-demuxer=ac3 \
	--enable-demuxer=avi \
	--enable-demuxer=mov \
	--enable-demuxer=vc1 \
	--enable-demuxer=mjpeg \
	--enable-demuxer=mpegts \
	--enable-demuxer=mpegtsraw \
	--enable-demuxer=mpegps \
	--enable-demuxer=mpegvideo \
	--enable-demuxer=wav \
	--enable-demuxer=pcm_s16be \
	--enable-demuxer=mp3 \
	--enable-demuxer=pcm_s16le \
	--enable-demuxer=matroska \
	--enable-demuxer=flv \
	--enable-demuxer=rm \
	--enable-demuxer=rtsp \
	--enable-demuxer=hls \
	--enable-demuxer=dts \
	--enable-demuxer=wav \
	--enable-demuxer=ogg \
	--enable-demuxer=flac \
	--enable-demuxer=srt \
	--enable-demuxer=hds \
	--disable-encoders \
	--disable-muxers \
	--enable-muxer=mpegts \
	--disable-filters \
	--disable-protocol=data \
	--disable-protocol=cache \
	--disable-protocol=concat \
	--disable-protocol=crypto \
	--disable-protocol=ftp \
	--disable-protocol=gopher \
	--disable-protocol=httpproxy \
	--disable-protocol=pipe \
	--disable-protocol=sctp \
	--disable-protocol=srtp \
	--disable-protocol=subfile \
	--disable-protocol=unix \
	--disable-protocol=md5 \
	--disable-protocol=hls \
	--enable-protocol=file \
	--enable-protocol=http \
	--enable-protocol=https \
	--enable-protocol=mmsh \
	--enable-protocol=mmst \
	--enable-protocol=rtp \
	--enable-protocol=tcp \
	--enable-protocol=udp \
	--enable-bsfs \
	--disable-devices \
	--enable-swresample \
	--disable-postproc \
	--disable-swscale \
	--enable-nonfree \
"

EXTRA_OECONF_append_coolstream-hd1 = " \
	--cpu=armv6 \
	--disable-vfp \
"

EXTRA_OECONF_append_coolstream-hd2 = " \
	--cpu=cortex-a9 \
	--enable-vfp \
"

do_configure() {
    # We don't have TARGET_PREFIX-pkgconfig
    sed -i '/pkg_config_default="${cross_prefix}${pkg_config_default}"/d' ${S}/configure
    mkdir -p ${B}
    cd ${B}
    ${S}/configure ${EXTRA_OECONF}
    sed -i -e s:Os:O4:g ${B}/config.h
}

do_install_append() {
    install -m 0644 ${S}/libavfilter/*.h ${D}${includedir}/libavfilter/
}

