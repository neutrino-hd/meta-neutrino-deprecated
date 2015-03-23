# Base this image on core-image-minimal
include recipes-core/images/core-image-minimal.bb

# 488M + 20MB /boot +4MB alignment = 512M
IMAGE_ROOTFS_SIZE = "499712"

# add default password for root

ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd;"
set_root_passwd() {
   sed 's%^root:[^:]*:%root:wYNffsf6sozwE:%' \
       < ${IMAGE_ROOTFS}/etc/shadow \
       > ${IMAGE_ROOTFS}/etc/shadow.new;
   mv ${IMAGE_ROOTFS}/etc/shadow.new ${IMAGE_ROOTFS}/etc/shadow ;
}

# all but not neutrino :-)
IMAGE_INSTALL += " \
    packagegroup-custom-needed \
"
# don´t install kernel-modules for tiny images
IMAGE_INSTALL += "${@'kernel-modules' if IMAGETYPE != 'tiny' else ''}"

# put kernel binary into the image
IMAGE_INSTALL += "${@'kernel-image' if INCLUDE_KERNEL == 'yes' else ''}"

EXTRAOPKGCONFIG = "neutrino-feed-config"


