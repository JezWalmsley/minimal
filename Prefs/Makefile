include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = minimalPrefs

minimalPrefs_FILES = NOTRootListController.m
minimalPrefs_FRAMEWORKS = UIKit
minimalPrefs_PRIVATE_FRAMEWORKS = Preferences
minimalPrefs_EXTRA_FRAMEWORKS = CepheiPrefs Cephei
minimalPrefs_LIBRARIES = gcuniversal
minimalPrefs_INSTALL_PATH = /Library/PreferenceBundles
minimalPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
