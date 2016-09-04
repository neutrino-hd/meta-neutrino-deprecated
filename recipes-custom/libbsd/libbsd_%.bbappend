FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append += " \
		   file://dont_build_nlist.patch \
"
