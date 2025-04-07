export ARCHS = arm64 arm64e
export TARGET = iphone:clang:13.7:13.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS13.7.sdk
export PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

INSTALL_TARGET_PROCESSES = SpringBoard Preferences
SUBPROJECTS = Tweak Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

ifeq ($(THEOS_PACKAGE_SCHEME), rootless)
before-package::
	$(ECHO_NOTHING)find .theos/_ -name "*.caml" -exec sed -i '' -e 's/\/var\/mobile/\/var\/jb\/var\/mobile/g' {} \;$(ECHO_END)
endif
