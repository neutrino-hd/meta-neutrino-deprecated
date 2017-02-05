SUMMARY = "Hierarchical, reference counted memory pool system with destructors"
HOMEPAGE = "http://ldb.samba.org"
SECTION = "libs"
LICENSE = "LGPL-3.0"

DEPENDS += "libtdb talloc libtevent popt openldap libbsd"
RDEPENDS_${PN} += "libtevent popt libtalloc openldap"
RDEPENDS_pyldb += "python libtdb libtalloc"

SRC_URI = "https://samba.org/ftp/ldb/ldb-${PV}.tar.gz \
	   file://do-not-import-target-module-while-cross-compile.patch \
	   file://dont_use_latest_tevent.patch \
"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/LGPL-3.0;md5=bfccfe952269fff2b407dd11f2f3083b \
                    file://${COREBASE}/meta/files/common-licenses/LGPL-2.1;md5=1a6d268fd218675ffea8be556788b780 \
                    file://${COREBASE}/meta/files/common-licenses/GPL-3.0;md5=c79ff39f19dfec6d293b95dea7b07891"

SRC_URI[md5sum] = "50a194dea128d062cf4b44c59130219b"
SRC_URI[sha256sum] = "cdb8269cba09006ddf3766eb7721192b52ae3fdc8a6b95f4318b6b740b9d35ac"

inherit waf-samba

S = "${WORKDIR}/ldb-${PV}"

EXTRA_OECONF += "--disable-rpath \
                 --disable-rpath-install \
                 --bundled-libraries=NONE \
                 --builtin-libraries=replace \
                 --with-modulesdir=${libdir}/ldb/modules \
                 --with-privatelibdir=${libdir}/ldb \
                 --with-libiconv=${STAGING_DIR_HOST}${prefix}\
                "

PACKAGES += "pyldb pyldb-dbg pyldb-dev"

FILES_${PN} += "${libdir}/ldb/*"
FILES_${PN}-dbg += "${libdir}/ldb/.debug/* \
                    ${libdir}/ldb/modules/ldb/.debug/*"

FILES_pyldb = "${libdir}/python${PYTHON_BASEVERSION}/site-packages/* \
               ${libdir}/libpyldb-util.so.1 \
               ${libdir}/libpyldb-util.so.1.1.27 \
              "
FILES_pyldb-dbg = "${libdir}/python${PYTHON_BASEVERSION}/site-packages/.debug \
                   ${libdir}/.debug/libpyldb-util.so.1.1.27"
FILES_pyldb-dev = "${libdir}/libpyldb-util.so"
