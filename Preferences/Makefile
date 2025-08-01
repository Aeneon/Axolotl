BUNDLE_NAME = AxolotlPrefs

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	export SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
	export TARGET = iphone:clang:latest:15.0
	export ARCHS = arm64 arm64e

	$(BUNDLE_NAME)_IDENTIFIER = com.macthemes.axolotl~rootless

	THEOS_STAGING_DIR = ../Packages/$($(BUNDLE_NAME)_IDENTIFIER)/$(THEOS_PACKAGE_INSTALL_PREFIX)/
else
	export SYSROOT = $(THEOS)/sdks/iPhoneOS11.4.sdk
	export TARGET = iphone:clang:latest:11.0
	export ARCHS = arm64 arm64e

	$(BUNDLE_NAME)_IDENTIFIER = com.macthemes.axolotl

	THEOS_STAGING_DIR = ../Packages/$($(BUNDLE_NAME)_IDENTIFIER)/
endif

DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

$(BUNDLE_NAME)_CFLAGS = -fobjc-arc
$(BUNDLE_NAME)_FILES = $(wildcard *.m)
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp AxolotlPrefs.plist $(THEOS_STAGING_DIR)Library/PreferenceLoader/Preferences/AxolotlPrefs.plist$(ECHO_END)
