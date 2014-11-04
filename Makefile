include theos/makefiles/common.mk

SUBPROJECTS += slide2kill8litesettings

export ARCHS = armv7 arm64

TWEAK_NAME = Slide2Kill8Lite
Slide2Kill8Lite_FILES = Tweak.xm
Slide2Kill8Lite_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk