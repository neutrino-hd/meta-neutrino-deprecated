UCLIBCPATCHES_libc-uclibc = "${@'' if DISTRO != 'fido' else ' \
	file://0001-uclibc-nss.patch \
	file://0002-uclibc-rpcsvc-defines.patch'}"
