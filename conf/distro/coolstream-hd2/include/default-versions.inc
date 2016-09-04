#
# Default preferred versions
#
# currently usable kernel version, use the same for headers
KV = "3.10.93"
LINUXLIBCVERSION ?= "4.4"

PREFERRED_VERSION_luaposix = "31"
# Force the python versions in one place
PYTHON_BASEVERSION ?= "2.%"
PREFERRED_VERSION_python ?= "2.%"
PREFERRED_VERSION_python-native ?= "2.%"

# Force the older version of liberation-fonts until we fix the fontforge issue
PREFERRED_VERSION_liberation-fonts ?= "1.04"

# Force db-native's version to keep sync with db while
# 'AGPL-3.0' in ${INCOMPATIBLE_LICENSE} blacklist
PREFERRED_VERSION_db-native = "${@incompatible_license_contains('AGPL-3.0', '5.%', '6.%', d)}"
PREFERRED_VERSION_opkg = "0.3%"
PREFERRED_VERSION_opkg_native = "0.3%"
PREFERRED_VERSION_busybox = "1.24.1"

