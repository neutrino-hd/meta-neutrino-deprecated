# Base this image on core-image-minimal
include recipes-core/images/core-image-minimal.bb

# 488M + 20MB /boot +4MB alignment = 512M
IMAGE_ROOTFS_SIZE = "499712"

# add default password for root
inherit extrausers
     
EXTRA_USERS_PARAMS = "\
	              useradd -P root root; \
"

# all but not neutrino :-)
IMAGE_INSTALL += " \
    packagegroup-custom-needed \
"

EXTRAOPKGCONFIG = "neutrino-feed-config"


