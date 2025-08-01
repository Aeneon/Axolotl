TWEAK_NAME = Axolotl

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
	export TARGET = iphone:clang:latest:15.0
	export ARCHS = arm64 arm64e

	$(TWEAK_NAME)_CFLAGS = -fobjc-arc -std=c++11 -Wno-deprecated
	$(TWEAK_NAME)_IDENTIFIER = com.macthemes.axolotl~rootless

	THEOS_STAGING_DIR = Packages/$($(TWEAK_NAME)_IDENTIFIER)/$(THEOS_PACKAGE_INSTALL_PREFIX)/
else
	export SYSROOT = $(THEOS)/sdks/iPhoneOS11.4.sdk
	export TARGET = iphone:clang:latest:11.0
	export ARCHS = arm64 arm64e

	$(TWEAK_NAME)_CFLAGS = -fobjc-arc
	$(TWEAK_NAME)_IDENTIFIER = com.macthemes.axolotl

	THEOS_STAGING_DIR = Packages/$($(TWEAK_NAME)_IDENTIFIER)/
endif

DEBUG = 0
FINALPACKAGE = 1

THEOS_STAGING_DIR_ROOT = Packages/$($(TWEAK_NAME)_IDENTIFIER)/

include $(THEOS)/makefiles/common.mk

$(TWEAK_NAME)_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences

include $(THEOS_MAKE_PATH)/aggregate.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR_ROOT)DEBIAN$(ECHO_END)
	$(ECHO_NOTHING)cp Debian/$($(TWEAK_NAME)_IDENTIFIER)/DEBIAN/* $(THEOS_STAGING_DIR_ROOT)DEBIAN/$(ECHO_END)
	$(ECHO_NOTHING)$(THEOS_BIN_PATH)/convert_xml_plist.sh -D $(THEOS_STAGING_DIR_ROOT)$(ECHO_END)
	$(ECHO_NOTHING)$(THEOS_PROJECT_DIR)/SetFileChangeDate $(THEOS_STAGING_DIR_ROOT)$(ECHO_END)
