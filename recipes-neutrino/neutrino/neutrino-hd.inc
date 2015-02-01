# configure stuff goes here
#
N_CFLAGS = "-Wall -Wextra -Wshadow -g -O2 -fno-strict-aliasing -rdynamic -DENABLE_FREESATEPG -DNEW_LIBCURL -I${STAGING_INCDIR}/freetype2"

N_CXXFLAGS = "${N_CFLAGS}"

N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib -lcurl -lssl -lcrypto -ldl"

N_CPPFLAGS = "-DDYNAMIC_LUAPOSIX -D__KERNEL_STRICT_NAMES "
N_CPPFLAGS_append_coolstream-hd2 = "-DFB_HW_ACCELERATION -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard" 


CPPFLAGS = "${N_CPPFLAGS}"

EXTRA_OECONF = " \
	--enable-maintainer-mode \
	--enable-pip \
	--enable-silent-rules \
	--enable-mdev \
	--enable-lua \
	--enable-upnp \
	--with-tremor \
	--enable-giflib \
	--enable-flac \
	--enable-ffmpegdec \
	--with-boxtype=coolstream \
"

EXTRA_OECONF_append_coolstream-hd1 = " \
	--with-boxmodel=nevis \
"

EXTRA_OECONF_append_coolstream-hd2 = " \
	--with-boxmodel=apollo \
"
