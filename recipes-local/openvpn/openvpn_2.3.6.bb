require openvpn.inc

PR = "1"
SRC_URI = "http://openvpn.net/release/${P}.tar.gz \
	   file://openvpn"

# I want openvpn to be able to read password from file (hrw)
EXTRA_OECONF += "--enable-password-save"
DEFAULT_PREFERENCE = "-1"

SRC_URI[md5sum] = "6ca03fe0fd093e0d01601abee808835c"
SRC_URI[sha256sum] = "7baed2ff39c12e1a1a289ec0b46fcc49ff094ca58b8d8d5f29b36ac649ee5b26"

