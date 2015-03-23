# Base this image on core-image-minimal
include recipes-core/images/core-image-minimal.bb

# 488M + 20MB /boot +4MB alignment = 512M
IMAGE_ROOTFS_SIZE = "499712"

# add default password for root
inherit extrausers
     
EXTRA_USERS_PARAMS = "\
	              usermod -P root root; \
"

# all but not neutrino :-)
IMAGE_INSTALL += " \
    packagegroup-custom-needed \
"
# don´t install kernel-modules for tiny images
IMAGE_INSTALL += "${@'kernel-modules' if IMAGETYPE != 'tiny' else ''}"

# put kernel binary into the image
IMAGE_INSTALL += "${@'kernel-image' if INCLUDE_KERNEL == 'yes' else ''}"

EXTRAOPKGCONFIG = "neutrino-feed-config"


