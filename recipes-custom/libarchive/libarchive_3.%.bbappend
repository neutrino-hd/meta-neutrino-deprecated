PACKAGECONFIG ?= "${@'xml2 zlib bz2' if DISTRO != 'coolstream-hd1_flash' else 'zlib bz2'}"
