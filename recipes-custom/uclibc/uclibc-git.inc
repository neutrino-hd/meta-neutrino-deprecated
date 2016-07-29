SRCREV = "0c0186440063bab824a8a9341d3cf0e27d98f2b8"

PV = "1.0.16+git${SRCPV}"

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

