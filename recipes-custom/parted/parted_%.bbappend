DEPENDS = "ncurses readline util-linux virtual/libiconv"

EXTRA_OECONF_libc-uclibc = "--disable-device-mapper \
			    LIBS="-liconv" \
"
