//
//  Passcode.m
//  HoYosphere
//
//  Created by Alexandra Aurora Göttlicher
//

#import "Passcode.h"

#pragma mark - SBUIPasscodeLockNumberPad class hooks

/**
 * Adds the character icons to the passcode pads.
 */
static void (* orig_SBUIPasscodeLockNumberPad_didMoveToWindow)(SBUIPasscodeLockNumberPad* self, SEL _cmd);
static void override_SBUIPasscodeLockNumberPad_didMoveToWindow(SBUIPasscodeLockNumberPad* self, SEL _cmd) {
    orig_SBUIPasscodeLockNumberPad_didMoveToWindow(self, _cmd);

    for (SBPasscodeNumberPadButton* button in [self buttons]) {
        if ([button character] < 0 || [button character] > 10) {
            continue;
        }

        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@/Passcode/%lld.png", kDocumentPath, pfStyle, [button character]]]];
        [imageView setFrame:[[button circleView] frame]];
        [[[button circleView] superview] addSubview:imageView];
    }
}

#pragma mark - Preferences

/**
 * Loads the user's preferences.
 */
static void load_preferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:kPreferencesIdentifier];

    [preferences registerDefaults:@{
        kPreferenceKeyEnabled: @(kPreferenceKeyEnabledDefaultValue),
        kPreferenceKeyStyle: kPreferenceKeyStyleDefaultValue
    }];

    pfEnabled = [[preferences objectForKey:kPreferenceKeyEnabled] boolValue];
    pfStyle = [preferences objectForKey:kPreferenceKeyStyle];
}

#pragma mark - Constructor

/**
 * Initializes the Tweak.
 */
__attribute((constructor)) static void initialize() {
    load_preferences();

    if (!pfEnabled) {
        return;
    }

    MSHookMessageEx(objc_getClass("SBUIPasscodeLockNumberPad"), @selector(didMoveToWindow), (IMP)override_SBUIPasscodeLockNumberPad_didMoveToWindow, (IMP *)&orig_SBUIPasscodeLockNumberPad_didMoveToWindow);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)kNotificationKeyPreferencesReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
