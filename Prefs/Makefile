TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MinimalPrefs

MinimalPrefs_FILES = $(wildcard *.m)
MinimalPrefs_FRAMEWORKS = UIKit
MinimalPrefs_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
MinimalPrefs_INSTALL_PATH = /Library/PreferenceBundles
MinimalPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Minimal.plist$(ECHO_END)
