include theos/makefiles/common.mk

TWEAK_NAME = PIPEnabler
PIPEnabler_FILES = Tweak.xm
PIPEnabler_LIBRARIES = MobileGestalt
PIPEnabler_FRAMEWORKS = CydiaSubstrate CoreFoundation Foundation UIKit
PIPEnabler_LDFLAGS = -Wl,-segalign,4000

export ARCHS = armv7 arm64
PIPEnabler_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
	
	
all::
	@echo "[+] Copying Files..."
	@cp ./obj/obj/debug/PIPEnabler.dylib //Library/MobileSubstrate/DynamicLibraries/PIPEnabler.dylib
	@/usr/bin/ldid -S //Library/MobileSubstrate/DynamicLibraries/PIPEnabler.dylib
	@echo "DONE"
	#@killall SpringBoard
	