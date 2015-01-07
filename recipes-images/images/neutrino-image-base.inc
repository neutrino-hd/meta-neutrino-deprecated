# Base this image on core-image-minimal
include recipes-core/images/core-image-minimal.bb

# 488M + 20MB /boot +4MB alignment = 512M
IMAGE_ROOTFS_SIZE = "499712"

IMAGE_DEPENDS += " \
	e2fsprogs \
"

# all but not neutrino :-)
IMAGE_INSTALL += " \
	strace \
	procps \
	image-config \
	virtual/stb-hal-libs \
	e2fsprogs-mke2fs \
	e2fsprogs-e2fsck \
	e2fsprogs-tune2fs \
	vsftpd \
	udpxy \
	xupnpd \
	fbshot \
	opkg \
"


# Tripledragon Kernel is too old for udev
IMAGE_INSTALL += "${@'udev-extraconf' if MACHINE != 'tripledragon' else ''}"

# Include modules in rootfs, but not on hd1, where
# flash is small...
IMAGE_INSTALL += "${@'kernel-modules' if MACHINE != 'coolstream-hd1' else ''}"

# we must not compile autofs for hd2
#IMAGE_INSTALL += "${@'autofs' if MACHINE != 'coolstream-hd2' else ''}"

EXTRAOPKGCONFIG = "neutrino-feed-config"

IMAGE_INSTALL += "${@'mc tmux nano samba nfs-utils cifs-utils mtd-utils man man-pages tmux-doc vim diffutils ushare djmount openssh' if IMAGETYPE != 'flashimage' else ''}"

