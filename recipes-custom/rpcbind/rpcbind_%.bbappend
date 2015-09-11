UCLIBCPATCHES_libc-uclibc = "${@'' if DISTRO_VERSION != 'fido' else '\
	file://0002-uclibc-rpcsvc-defines.patch'}"
