Compatible_TCLIBC = "uclibc"

FILESEXTRAPATHS_prepend := "${THISDIR}/gnome-desktop-testing:"

SRC_URI += "file://define_o_cloexec.patch"
