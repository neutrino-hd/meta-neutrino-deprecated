# Base this image on core-image-minimal

include neutrino-image-base.inc

IMAGE_INSTALL += " \
	${NEUTRINO_FLAVOUR} \
	neutrino-plugins \
	neutrino-plugin-xupnpd \
	neutrino-plugin-netzkino \
	neutrino-plugin-rss \
	neutrino-plugin-localtv \
	neutrino-plugin-buli \
	neutrino-plugin-wetter \
	neutrino-plugin-mtv \
	neutrino-plugin-mytvpro \
	neutrino-plugin-myspass \
	neutrino-plugin-mediathek \
	neutrino-plugin-youtube \
	neutrino-plugin-webtv \
	neutrino-plugin-rockpalast \
	"
