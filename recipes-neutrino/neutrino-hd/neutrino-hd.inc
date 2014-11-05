# configure stuff goes here
#
N_CFLAGS = "-Wall -W -Wshadow -g -O2 -fno-strict-aliasing -funsigned-char"

N_CXXFLAGS = "${N_CFLAGS}"

N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib"

N_CPPFLAGS = "${@'-DDYNAMIC_LUAPOSIX -DENABLE_FREESATEPG -DNEW_LIBCURL -D__KERNEL_STRICT_NAMES' if MACHINE != 'coolstream-hd2' else '-DDYNAMIC_LUAPOSIX -DENABLE_FREESATEPG -DNEW_LIBCURL -D__KERNEL_STRICT_NAMES -DFB_HW_ACCELERATION -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard '}"

CPPFLAGS = "${N_CPPFLAGS}"

EXTRA_OECONF_append = " \
	--enable-maintainer-mode \
	--enable-pip \
	--with-target=native \
	--enable-silent-rules \
	--enable-mdev \
	--enable-lua \
	--enable-upnp \
	--with-tremor \
	--enable-giflib \
	--enable-flac \
	--with-boxtype=coolstream \
"

EXTRA_OECONF_coolstream-hd1 += " \
	--with-boxmodel=nevis \
"

EXTRA_OECONF_coolstream-hd2 += " \
	--with-boxmodel=apollo \
"
