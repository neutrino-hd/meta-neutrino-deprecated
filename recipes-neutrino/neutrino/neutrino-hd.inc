# configure stuff goes here
#
N_CFLAGS = "-Wall -Wextra -Wshadow -g -O2 -fno-strict-aliasing -rdynamic -DENABLE_FREESATEPG -DNEW_LIBCURL"

N_CXXFLAGS = "${N_CFLAGS} -std=c++11"

N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib -lcurl -ldl "

N_CPPFLAGS = "-DDYNAMIC_LUAPOSIX -D__KERNEL_STRICT_NAMES -D_GLIBCXX_USE_CXX11_ABI=1 -D__STDC_CONSTANT_MACROS"
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
	--enable-pugixml \
	--enable-ffmpegdec \
	--with-boxtype=coolstream \
	--prefix=/usr \
	--exec_prefix=/usr/bin \
	--includedir=${prefix}/include \
	--with-configdir=/etc/neutrino/config \
	--with-plugindir=/etc/neutrino/plugins \
	--with-webtvdir_var=/etc/neutrino/plugins/webtv \
	--with-luaplugindir=/etc/neutrino/plugins \
	--with-plugindir_var=/etc/neutrino/plugins \
	--with-gamesdir=/etc/neutrino/plugins \
	--with-webtvdir_var=/etc/neutrino/plugins/webtv \
	--with-plugindir_var=/etc/neutrino/plugins \
"

EXTRA_OECONF_append_coolstream-hd1 = " \
	--with-boxmodel=hd1 \
"

EXTRA_OECONF_append_coolstream-hd2 = " \
	--with-boxmodel=hd2 \
"


