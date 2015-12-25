do_compile () {
	oe_runmake 'CC=${CC} -D_GNU_SOURCE -lm' VPATH="${STAGING_LIBDIR}:${STAGING_DIR_HOST}/${base_libdir}" all man
}
