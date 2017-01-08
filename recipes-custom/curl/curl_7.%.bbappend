DEPENDS = "zlib openssl"

EXTRA_OECONF += "--with-librtmp \
		 --with-ssl \
		 --with-zlib \
"
