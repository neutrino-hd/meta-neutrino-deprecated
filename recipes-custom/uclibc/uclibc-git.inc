SRCREV = "b2d83aba010076b234d6290a91bb824e926e35bb"

PV = "1.0.17"

FILESEXTRAPATHS =. "${FILE_DIRNAME}/uclibc-git:"

SRC_URI = "git://uclibc-ng.org/git/uclibc-ng \
        file://0001-Disable-lrount_tes-function.patch \
        file://uClibc.machine \
        file://uClibc.distro \
        file://obstack.cfg \
        file://locale.cfg \
"
S = "${WORKDIR}/git"

UPSTREAM_CHECK_GITTAGREGEX = "(?P<pver>\d+\.\d+(\.\d+)*)"

