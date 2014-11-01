# Base this image on core-image-minimal

include neutrino-image-base.inc

IMAGE_INSTALL += " \
	vsftpd \
	neutrino-hd \
	neutrino-hd-plugin-ard \
	neutrino-hd-plugin-xupnpd \
	"
