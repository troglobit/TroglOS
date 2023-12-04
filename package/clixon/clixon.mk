################################################################################
#
# clixon
#
################################################################################

#CLIXON_VERSION = 6.0.0
#CLIXON_SITE = $(call github,clicon,clixon,$(CLIXON_VERSION))
CLIXON_VERSION = 3d7f1099a6aa7889b3a0645184089148ef511bf3
CLIXON_SITE = https://github.com/kernelkit/clixon
CLIXON_SITE_METHOD = git

CLIXON_LICENSE = Apache-2.0
CLIXON_LICENSE_FILES = LICENSE.md
CLIXON_INSTALL_STAGING = YES
CLIXON_DEPENDENCIES = cligen openssl #libcurl libxml2

CLIXON_CONF_OPTS = INSTALLFLAGS=" "

# autotools-package.mk dutifully sets sysconfdir to /etc, but
# unfortunately clixon uses a hard-coded default location of
# /usr/local/etc/clixon.xml unless this option is specified.
CLIXON_CONF_OPTS += --with-configfile=/etc/clixon.xml

ifeq ($(BR2_PACKAGE_CLIXON_RESTCONF_NATIVE),y)
CLIXON_CONF_OPTS += --with-restconf=native
endif

ifeq ($(BR2_PACKAGE_CLIXON_HTTP1),y)
CLIXON_CONF_OPTS += --enable-http1
else
CLIXON_CONF_OPTS += --disable-http1
endif

ifeq ($(BR2_PACKAGE_CLIXON_HTTP2),y)
CLIXON_DEPENDENCIES += nghttp2
CLIXON_CONF_OPTS += --enable-nghttp2
else
CLIXON_CONF_OPTS += --disable-nghttp2
endif

ifeq ($(BR2_PACKAGE_CLIXON_RESTCONF_FCGI),y)
CLIXON_DEPENDENCIES += nginx libfcgi
CLIXON_CONF_OPTS += --with-restconf=fcgi
endif

ifeq ($(BR2_PACKAGE_CLIXON_RESTCONF_NONE),y)
CLIXON_CONF_OPTS += --without-restconf
endif

ifeq ($(BR2_PACKAGE_CLIXON_PUBLISH),y)
CLIXON_CONF_OPTS += --enable-publish
else
CLIXON_CONF_OPTS += --disable-publish
endif

ifeq ($(BR2_PACKAGE_CLIXON_SNMP),y)
CLIXON_DEPENDENCIES += netsnmp
CLIXON_CONF_OPTS += --enable-netsnmp
else
CLIXON_CONF_OPTS += --disable-netsnmp
endif

ifeq ($(BR2_PACKAGE_CLIXON_EXAMPLE),y)
define CLIXON_INSTALL_EXAMPLE
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install-example
endef
CLIXON_POST_INSTALL_TARGET_HOOKS += CLIXON_INSTALL_EXAMPLE
endif

define CLIXON_INSTALL_EXTRA
	rm -rf $(TARGET_DIR)/var/clixon
	ln -sf clixon_cli $(TARGET_DIR)/usr/bin/clish
	grep -qsE '^/usr/bin/clish$$' "$(TARGET_DIR)/etc/shells" \
		|| echo "/usr/bin/clish" >> "$(TARGET_DIR)/etc/shells"
endef
CLIXON_POST_INSTALL_TARGET_HOOKS += CLIXON_INSTALL_EXTRA

$(eval $(autotools-package))
