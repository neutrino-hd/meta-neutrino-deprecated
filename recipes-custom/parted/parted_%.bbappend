DEPENDS_libc-uclibc = "ncurses readline util-linux libiconv"

EXTRA_OECONF_libc-uclibc = "--disable-device-mapper \
			    LIBS="-liconv" \
"
