include $(TOPDIR)/rules.mk

PKG_NAME:=UA2FCPP
PKG_VERSION:=3.99
PKG_RELEASE:=1

PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILE:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/ua2fcpp
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  TITLE:=Change User-Agent to Fwords on the fly.
  URL:=https://github.com/imguoliwei/UA2F-cpp
  DEPENDS:=+libstdcpp +iptables-mod-conntrack-extra +iptables-mod-nfqueue \
    +libnetfilter-conntrack +libnetfilter-queue
endef

define Package/ua2fcpp/description
  Change User-agent to Fwords to prevent being checked by Dr.Com.
endef

define Build/Compile
	$(TARGET_CXX) -Wall -Werror -fno-rtti -fno-exceptions -std=c++17 -L$(STAGING_DIR)/usr/include/ -L$(STAGING_DIR)/usr/lib/ -O3 \
		$(PKG_BUILD_DIR)/ua2f.cpp -o $(PKG_BUILD_DIR)/ua2fcpp \
		-lmnl -lnetfilter_queue -lnfnetlink -lpthread
endef

define Package/ua2fcpp/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ua2fcpp $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/config $(1)/etc/init.d $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/ua2fcpp.config $(1)/etc/config/ua2fcpp
	$(INSTALL_BIN) ./files/ua2fcpp.init $(1)/etc/init.d/ua2fcpp
	$(INSTALL_BIN) ./files/ua2fcpp.uci $(1)/etc/uci-defaults/80-ua2fcpp
endef

define Package/ua2fcpp/postinst
#!/bin/sh

# check if we are on real system
[ -n "$${IPKG_INSTROOT}" ] || {
	(. /etc/uci-defaults/80-ua2fcpp) && rm -f /etc/uci-defaults/80-ua2fcpp
	exit 0
}
endef

$(eval $(call BuildPackage,ua2fcpp))
