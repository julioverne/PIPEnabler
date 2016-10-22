include theos/makefiles/common.mk

BUNDLE_NAME = PIPEnablerSettings
PIPEnablerSettings_FILES = PIPEnablerSettingsController.mm
PIPEnablerSettings_INSTALL_PATH = /Library/PreferenceBundles
PIPEnablerSettings_FRAMEWORKS = UIKit QuartzCore CoreGraphics MessageUI Social Twitter
PIPEnablerSettings_PRIVATE_FRAMEWORKS = Preferences
PIPEnablerSettings_CFLAGS = -fobjc-arc
PIPEnablerSettings_LDFLAGS = -Wl,-segalign,4000
PIPEnablerSettings_ARCHS = armv7 arm64
export ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/bundle.mk

all::
	@echo "[+] Copying Files..."
	@cp ./obj/PIPEnablerSettings.bundle/PIPEnablerSettings //Library/PreferenceBundles/PIPEnablerSettings.bundle/PIPEnablerSettings
	@ldid -S //Library/PreferenceBundles/PIPEnablerSettings.bundle/PIPEnablerSettings
	@echo "DONE"
	
	