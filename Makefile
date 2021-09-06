TARGET := iphone:clang:latest:12.2
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Minimal

Minimal_FILES = $(shell find Sources/Minimal -name '*.swift') $(shell find Sources/MinimalC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Minimal_SWIFTFLAGS = -ISources/MinimalC/include
Minimal_CFLAGS = -fobjc-arc -ISources/MinimalC/include

include $(THEOS_MAKE_PATH)/tweak.mk
