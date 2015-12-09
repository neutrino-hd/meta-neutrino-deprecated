require openvpn.inc

PR = "1"
SRC_URI = "https://swupdate.openvpn.org/community/releases/${P}.tar.gz \
	   file://openvpn"

# I want openvpn to be able to read password from file (hrw)
EXTRA_OECONF += "--enable-password-save"
DEFAULT_PREFERENCE = "-1"

SRC_URI[md5sum] = "51d996f1f1fc30f501ae251a254effeb"
SRC_URI[sha256sum] = "532435eff61c14b44a583f27b72f93e7864e96c95fe51134ec0ad4b1b1107c51"

