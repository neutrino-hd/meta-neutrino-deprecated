DESCRIPTION = "Matze Settings A+H 05.11.2016,Danke Matze"
LICENSE = "proprietary"
LIC_FILES_CHKSUM = "file://license;md5=17a6b3d5436a55985b200c725761907a"
HOMEPAGE = "http://matzesetting.brinkster.net/"

S = "${WORKDIR}"

PR = "r6"

SRC_URI = " \
        file://ubouquets.xml \
	file://services.xml \
	file://bouquets.xml \
	file://license \
"
do_install () {
	install -d ${D}/etc/neutrino/config/zapit  
        install -D -m 644 ${WORKDIR}/*.xml ${D}/etc/neutrino/config/zapit
}

FILES_${PN} = "\
    /etc/neutrino/config/zapit/ubouquets.xml \
    /etc/neutrino/config/zapit/services.xml \
    /etc/neutrino/config/zapit/bouquets.xml \
"

SRC_URI[md5sum] = "3668a887329a101e0db795a058eb330c"
SRC_URI[sha256sum] = "db3a1bd5c069ba4da71362eb98d397e03998b596ffd1171077008a0767592e40"
