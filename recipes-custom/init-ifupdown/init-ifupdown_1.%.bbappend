FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://interfaces \
"
do_configure_prepend () {
	sed -i "s|cooladdress|${COOLIP}|" ${WORKDIR}/interfaces
	sed -i "s|coolbroadcast|${COOLBROADCAST}|" ${WORKDIR}/interfaces
	sed -i "s|coolgateway|${COOLGATEWAY}|" ${WORKDIR}/interfaces
	sed -i "s|coolnameserver|${COOLDNS}|" ${WORKDIR}/interfaces
	sed -i "s|coolnetmask|${COOLNETMASK}|" ${WORKDIR}/interfaces
}
