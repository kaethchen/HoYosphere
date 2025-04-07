//
//  Time.m
//  HoYosphere
//
//  Created by Alexandra Aurora Göttlicher
//

#import "Time.h"

#pragma mark - SBFLockScreenDateView class hooks

/**
 * Overrides the default time font.
 *
 * @return The new time font.
 */
static UIFont* (* orig_SBFLockScreenDateView_timeFont)(SBFLockScreenDateView* self, SEL _cmd);
static UIFont* override_SBFLockScreenDateView_timeFont(SBFLockScreenDateView* self, SEL _cmd) {
    return [UIFont fontWithName:fontName size:[orig_SBFLockScreenDateView_timeFont(self, _cmd) pointSize]];
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

    // Load the corresponding font into memory.
    NSData* fontData;
    if ([pfStyle isEqualToString:kPreferenceKeyStyleGenshinImpact]) {
        fontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[kDocumentPath stringByAppendingString:@"/Genshin Impact/Time/HYWenHei.ttf"]]];
        fontName = @"HYWenHei 85W";
    } else {
        fontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[kDocumentPath stringByAppendingString:@"/Honkai Star Rail/Time/DIN.ttf"]]];
        fontName = @"DIN";
    }

    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);

    MSHookMessageEx(object_getClass(objc_getClass("SBFLockScreenDateView")), @selector(timeFont), (IMP)&override_SBFLockScreenDateView_timeFont, (IMP *)&orig_SBFLockScreenDateView_timeFont);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)load_preferences, (CFStringRef)kNotificationKeyPreferencesReload, NULL, (CFNotificationSuspensionBehavior)kNilOptions);
}
