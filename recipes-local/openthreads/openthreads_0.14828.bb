SUMMARY = "OpenThreads is a cross platform, object orientated threading library."
DESCRIPTION = "OpenThreads is a cross platform, object orientated threading library."
HOMEPAGE = "http://www.openscenegraph.org/"
SECTION = "libs"
LICENSE = "LGPL-2.1"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=2c38926f611bfbd5a3be0f817c8d2dad \
"
DEPENDS = ""

SRCREV = "${AUTOREV}"

SRC_URI = "git://bitbucket.org/neutrino-images/ni-openthreads/src;protocol=https \
"

S = "${WORKDIR}/git"



inherit cmake 

EXTRA_OECMAKE += "-DCMAKE_BUILD_TYPE=Release \
                  -DCMAKE_SYSTEM_NAME=Linux \
                  -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE=1 \
                  -D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS=1 \
"

ARM_INSTRUCTION_SET = "arm"
