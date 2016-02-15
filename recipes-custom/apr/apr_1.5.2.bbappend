FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
		file://configure.in-fix-LTFLAGS-to-make-it-work-with-ccache.patch \
"
