# configure stuff goes here
#
N_CFLAGS = "${@'-Wall -W -Wshadow -g -O2 -fno-strict-aliasing -funsigned-char -rdynamic -DENABLE_FREESATEPG -DNEW_LIBCURL -DUSETREMOR_TRUE=1' if MACHINE != 'coolstream-hd2' else '-Wall -W -Wshadow -g -O2 -fno-strict-aliasing -funsigned-char -rdynamic -DENABLE_FREESATEPG -DNEW_LIBCURL -DUSETREMOR_TRUE=1 -DENABLE_GIFLIB'}"

N_CXXFLAGS = "${N_CFLAGS}"

N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib"

N_CPPFLAGS = "${@'-DDYNAMIC_LUAPOSIX' if MACHINE != 'coolstream-hd2' else '-DDYNAMIC_LUAPOSIX -DFB_HW_ACCELERATION -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard -D__KERNEL_STRICT_NAMES'}"

CPPFLAGS = "${N_CPPFLAGS}"

EXTRA_OECONF_coolstream-hd1 = " \
	--enable-maintainer-mode \
	--enable-pip \
	--with-target=native \
	--enable-silent-rules \
	--enable-mdev \
	--enable-lua \
	--enable-upnp \
	--enable-flac \
	--with-boxtype=coolstream \
	--with-boxmodel=nevis \
"


EXTRA_OECONF_coolstream-hd2 = " \
	--enable-maintainer-mode \
	--enable-pip \
	--with-target=native \
	--enable-silent-rules \
	--enable-mdev \
	--enable-lua \
	--enable-upnp \
	--enable-flac \
	--enable-giflib \
	--with-boxtype=coolstream \
	--with-boxmodel=apollo \
"
