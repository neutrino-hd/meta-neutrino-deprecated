SUMMARY = "Vi IMproved - enhanced vi editor"
SECTION = "console/utils"
DEPENDS = "ncurses gettext-native"
# vimdiff doesn't like busybox diff
RSUGGESTS_${PN} = "diffutils"
LICENSE_PATH += "${THISDIR}/files:"
LICENSE = "vim"
LIC_FILES_CHKSUM = "file://../runtime/doc/uganda.txt;md5=c74ec0ada9a68354f9461e81d3596f61"
SRC_URI = "git://github.com/vim/vim.git \
           file://disable_acl_header_check.patch;patchdir=.. \
           file://vim-add-knob-whether-elf.h-are-checked.patch;patchdir=.. \
"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git/src"
PV = "${SRCPV}"
VIMDIR = "vim74"

inherit autotools-brokensep update-alternatives pkgconfig

# vim configure.in contains functions which got 'dropped' by autotools.bbclass
do_configure () {
    rm -f auto/*
    touch auto/config.mk
    aclocal
    autoconf
    oe_runconf
    touch auto/configure
    touch auto/config.mk auto/config.h
}

#Available PACKAGECONFIG options are gtkgui, acl, x11, tiny
PACKAGECONFIG ??= "tiny"
PACKAGECONFIG += "${@base_contains('DISTRO_FEATURES', 'acl', 'acl', '', d)}"
PACKAGECONFIG += "${@base_contains('DISTRO_FEATURES', 'selinux', 'selinux', '', d)}"

PACKAGECONFIG[gtkgui] = "--enable-gtk2-test --enable-gui=gtk2,--enable-gui=no,gtk+,"
PACKAGECONFIG[acl] = "--enable-acl,--disable-acl,acl,"
PACKAGECONFIG[x11] = "--with-x,--without-x,xt,"
PACKAGECONFIG[tiny] = "--with-features=tiny,--with-features=big,,"
PACKAGECONFIG[selinux] = "--enable-selinux,--disable-selinux,libselinux,"
PACKAGECONFIG[elfutils] = "--enable-elf-check,,elfutils,"

EXTRA_OECONF = " \
    --disable-gpm \
    --disable-gtktest \
    --disable-xim \
    --disable-netbeans \
    --with-tlib=ncurses \
    ac_cv_small_wchar_t=no \
    vim_cv_getcwd_broken=no \
    vim_cv_memmove_handles_overlap=yes \
    vim_cv_stat_ignores_slash=no \
    vim_cv_terminfo=yes \
    vim_cv_tgent=non-zero \
    vim_cv_toupper_broken=no \
    vim_cv_tty_group=world \
    STRIP=/bin/true \
"
do_install_append() {
    # Work around rpm picking up csh or awk or perl as a dep
    chmod -x ${D}${datadir}/${BPN}/${VIMDIR}/tools/vim132
    chmod -x ${D}${datadir}/${BPN}/${VIMDIR}/tools/mve.awk
    chmod -x ${D}${datadir}/${BPN}/${VIMDIR}/tools/*.pl

    # Install example vimrc from runtime files
    install -m 0644 ../runtime/vimrc_example.vim ${D}/${datadir}/${BPN}/vimrc
}

PACKAGES =+ "${PN}-common ${PN}-syntax ${PN}-help ${PN}-tutor ${PN}-vimrc"
FILES_${PN}-syntax = "${datadir}/${BPN}/${VIMDIR}/syntax"
FILES_${PN}-help = "${datadir}/${BPN}/${VIMDIR}/doc"
FILES_${PN}-tutor = "${datadir}/${BPN}/${VIMDIR}/tutor ${bindir}/${BPN}tutor"
FILES_${PN}-vimrc = "${datadir}/${BPN}/vimrc"
FILES_${PN}-data = "${datadir}/${BPN}"
FILES_${PN}-common = " \
    ${datadir}/${BPN}/${VIMDIR}/*.vim \
    ${datadir}/${BPN}/${VIMDIR}/autoload \
    ${datadir}/${BPN}/${VIMDIR}/colors \
    ${datadir}/${BPN}/${VIMDIR}/compiler \
    ${datadir}/${BPN}/${VIMDIR}/ftplugin \
    ${datadir}/${BPN}/${VIMDIR}/indent \
    ${datadir}/${BPN}/${VIMDIR}/keymap \
    ${datadir}/${BPN}/${VIMDIR}/lang \
    ${datadir}/${BPN}/${VIMDIR}/macros \
    ${datadir}/${BPN}/${VIMDIR}/plugin \
    ${datadir}/${BPN}/${VIMDIR}/print \
    ${datadir}/${BPN}/${VIMDIR}/spell \
    ${datadir}/${BPN}/${VIMDIR}/tools \
"

# Recommend that runtime data is installed along with vim
RRECOMMENDS_${PN} = "${PN}-syntax ${PN}-help ${PN}-tutor ${PN}-vimrc ${PN}-common"

ALTERNATIVE_${PN} = "vi"
ALTERNATIVE_TARGET[vi] = "${bindir}/${BPN}"
ALTERNATIVE_LINK_NAME[vi] = "${base_bindir}/vi"
ALTERNATIVE_PRIORITY[vi] = "100"

PARALLEL_MAKEINST = ""
