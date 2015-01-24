
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://sshd_config"

# no compile problems with uclibc here. therefore overriding default bb settings
EXTRA_OECONF_append_libc-uclibc=" --with-pam"

