# configure stuff goes here
#
N_CFLAGS = "-Wall -Wextra -Wshadow -g -O2 -fno-strict-aliasing -rdynamic -DENABLE_FREESATEPG -DNEW_LIBCURL -I${STAGING_INCDIR}/freetype2"

N_CXXFLAGS = "${N_CFLAGS}"

N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib -lcurl -ldl"

N_CPPFLAGS = "-DDYNAMIC_LUAPOSIX -D__KERNEL_STRICT_NAMES -D_GLIBCXX_USE_CXX11_ABI=0 -D__STDC_CONSTANT_MACROS -DFB_HW_ACCELERATION -mcpu=cortex-a9 -mfpu=vfpv3-d16 -mfloat-abi=hard -std=c++14"

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
	--prefix=/ \
	--exec_prefix=/usr \
	--includedir=${exec_prefix}/include \
	--with-configdir=${sysconfdir}/neutrino/config \
	--with-boxmodel=apollo \
"


