# include packagegroups

#IMAGE_INSTALL_append += "packagegroup-custom-link"
IMAGE_INSTALL_append += "${@'packagegroup-custom-recommended' if BOXMODEL != 'link' else 'packagegroup-custom-link'}"
