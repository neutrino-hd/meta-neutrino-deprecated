# Base this image on core-image-minimal
include recipes-core/images/core-image-minimal.bb

# 488M + 20MB /boot +4MB alignment = 512M
IMAGE_ROOTFS_SIZE = "499712"

# add default password for root

ROOTFS_POSTPROCESS_COMMAND += "set_root_passwd;"
set_root_passwd() {
   ROOTPW_ENCRYPTED=""
   if [ -n "${ROOTPW}" ]; then
   ROOTPW_ENCRYPTED=`openssl passwd -crypt -quiet ${ROOTPW}`
   else
   ROOTPW_ENCRYPTED="wYNffsf6sozwE"
   fi
   sed "s%^root:[^:]*:%root:${ROOTPW_ENCRYPTED}:%" \
       < ${IMAGE_ROOTFS}/etc/shadow \
       > ${IMAGE_ROOTFS}/etc/shadow.new;
   mv ${IMAGE_ROOTFS}/etc/shadow.new ${IMAGE_ROOTFS}/etc/shadow ;
}

IMAGE_POSTPROCESS_COMMAND_coolstream-hd2 += "copy_image_hd2;"
copy_image_hd2() {
	mkdir -p ${DEPLOY_DIR_IMAGE}/flashimage;
	cp ${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.jffs2.sum ${DEPLOY_DIR_IMAGE}/flashimage/rootfs.arm.jffs2.nand;
}

# all but not neutrino :-)
IMAGE_INSTALL += " \
    packagegroup-custom-needed \
"
# don´t install kernel-modules for tiny images
IMAGE_INSTALL += "${@'kernel-modules' if IMAGETYPE != 'tiny' else ''}"

# put kernel binary into the image
IMAGE_INSTALL += "${@'' if INCLUDE_KERNEL != 'yes' else 'kernel-image'}"

EXTRAOPKGCONFIG = "neutrino-feed-config"




