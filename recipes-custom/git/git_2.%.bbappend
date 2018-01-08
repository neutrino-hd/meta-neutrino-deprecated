DEPENDS = "zlib"

EXTRA_OEMAKE += "NO_GETTEXT=1 \
		 NO_PERL=1 \
		 NO_OPENSSL=1 \
		 NO_EXPAT=1 \
		 NO_TCLTK=1 \
		 NO_GETTEXT=1 \
		 NO_CURL=1 \
		 NO_PYTHON=1 \
		 NO_BLK_SHA1=1 \
"
perl_native_fixup () {
:
}

PERLTOOLS = ""

do_install_append() {
	rm -f ${WORKDIR}/image/usr/bin/git-shell
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-credential-cache
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-credential-cache--daemon
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-daemon
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-fast-import
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-upload-pack
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-imap-send
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-remote-testsvn
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-sh-i18n--envsubst
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-shell
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-show-index
	rm -f  ${WORKDIR}/image/usr/libexec/git-core/git-http-backend

}

