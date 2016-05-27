FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append +=" \
		file://locale.cfg \
		file://0001-provide_obstack_free-to-unbreak-build-with-native-gdb.patch \
"
