FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += "file://volatiles \
"

do_install_append () {
	install -m 0644    ${WORKDIR}/volatiles		${D}${sysconfdir}/default/volatiles/00_core
}
