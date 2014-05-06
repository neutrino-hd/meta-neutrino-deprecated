# configure stuff goes here
#
N_CFLAGS = "-Wall -W -Wshadow -g -O2 -fno-strict-aliasing -funsigned-char -rdynamic"
N_CXXFLAGS = "${N_CFLAGS}"
N_LDFLAGS += "-Wl,-rpath-link,${STAGING_DIR_HOST}/usr/lib"

N_CPPFLAGS = "-DDYNAMIC_LUAPOSIX"
CPPFLAGS = "${N_CPPFLAGS}"

EXTRA_OECONF = " \
	--enable-maintainer-mode \
	--enable-pip \
	--enable-lua \
	--with-target=native \
	--enable-silent-rules \
	--enable-mdev \
	--enable-upnp \
	--enable-flac \
	--with-boxtype=coolstream \
	--with-boxmodel=nevis \
"
