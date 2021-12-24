################################################################################
#
# mdnsd
#
################################################################################
MDNSD_VERSION = 0.10
MDNSD_SOURCE = mdnsd-$(MDNSD_VERSION).tar.xz
MDNSD_SITE = https://github.com/troglobit/mdnsd/releases/download/v$(MDNSD_VERSION)
MDNSD_LICENSE = BSD-3-Clause

define MDNSD_INSTALL_SAMPLE_CONFIG
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_MYLINUX_PATH)/package/mdnsd/ssh.service \
		$(TARGET_DIR)/etc/mdns.d/
endef

define MDNSD_INSTALL_FINIT_SVC
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL_MYLINUX_PATH)/package/mdnsd/mdnsd.svc \
		$(FINIT_D)/available/mdnsd.conf
	$(INSTALL) -d -m 0755 $(FINIT_D)/enabled
	ln -sf ../available/mdnsd.conf $(FINIT_D)/enabled/mdnsd.conf
endef

MDNSD_POST_INSTALL_TARGET_HOOKS += MDNSD_INSTALL_SAMPLE_CONFIG
MDNSD_POST_INSTALL_TARGET_HOOKS += MDNSD_INSTALL_FINIT_SVC

$(eval $(autotools-package))
