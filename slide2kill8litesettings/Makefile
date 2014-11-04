include theos/makefiles/common.mk

export ARCHS = armv7 arm64
BUNDLE_NAME = Slide2Kill8LiteSettings
Slide2Kill8LiteSettings_FILES = Slide2Kill8LiteSettings.mm
Slide2Kill8LiteSettings_INSTALL_PATH = /Library/PreferenceBundles
Slide2Kill8LiteSettings_FRAMEWORKS = UIKit
Slide2Kill8LiteSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Slide2Kill8LiteSettings.plist$(ECHO_END)
