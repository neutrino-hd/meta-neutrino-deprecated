FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_libc-uclibc += "file://0001-increase-max_summary_size.patch"
