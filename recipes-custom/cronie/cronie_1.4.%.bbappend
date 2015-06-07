FILESEXTRAPATHS_prepend := "${THISDIR}/cronie:"

SRC_URI += "file://crond.init \
	    file://crontab \
"

