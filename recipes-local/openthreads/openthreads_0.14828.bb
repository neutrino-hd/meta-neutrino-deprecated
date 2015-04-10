SUMMARY = "OpenThreads is a cross platform, object orientated threading library."
DESCRIPTION = "OpenThreads is a cross platform, object orientated threading library."
HOMEPAGE = "http://www.openscenegraph.org/"
SECTION = "libs"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://COPYING.txt;md5=9226151d58bcdf987ed14e7dc8cedcbc \
"
DEPENDS = ""

SRCREV = "14828"
PR = "r2"

SRC_URI = "svn://svn.openscenegraph.org/osg/OpenThreads;protocol=http;module=trunk \
           file://002-omit-policy-cmp0014.patch;pnum=0 \
"

S = "${WORKDIR}/trunk"

SRC_URI[md5sum] = "b9b88fc47d5452a18edcfd8463c0e94e"
SRC_URI[sha256sum] = "33ee0d1962769875ce18ca2a9aac40dc5cf6b6d2d83688cc00429c7ff1dbf22c"


inherit cmake 

EXTRA_OECMAKE += "-DCMAKE_BUILD_TYPE=Release \
                  -DCMAKE_SYSTEM_NAME=Linux \
                  -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
                  -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS=1 \
"

ARM_INSTRUCTION_SET = "arm"
