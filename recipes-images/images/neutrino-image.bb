# Base this image on core-image-minimal

include neutrino-image-base.inc

IMAGE_INSTALL += " \
	neutrino-hd \
	neutrino-hd-plugins \
	neutrino-hd-plugin-ard \
	neutrino-hd-plugin-xupnpd \
	neutrino-hd-plugin-netzkino \
	"
