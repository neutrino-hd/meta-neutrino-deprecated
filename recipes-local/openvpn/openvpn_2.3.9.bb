require openvpn.inc

PR = "1"
SRC_URI = "https://swupdate.openvpn.org/community/releases/${P}.tar.gz \
	   file://openvpn"

DEFAULT_PREFERENCE = "-1"

SRC_URI[md5sum] = "265755044ae88f9249d509f6d061f7e5"
SRC_URI[sha256sum] = "2c12fe9ea641ac1291e70322cc500641c84e5903dd4f40bf2eda7e9f209b2f9c"

