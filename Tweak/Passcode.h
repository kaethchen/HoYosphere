//
//  Passcode.h
//  HoYosphere
//
//  Created by Alexandra Aurora Göttlicher
//

#import "Common.h"

NSUserDefaults* preferences;
BOOL pfEnabled;
NSString* pfStyle;

@interface SBUIPasscodeLockNumberPad : UIView
@property(nonatomic, readonly)NSArray* buttons;
@end

@interface TPNumberPadButton : UIControl
@property(nonatomic)UIView* circleView;
@property(nonatomic, assign)long long character;
@end

@interface TPNumberPadDarkStyleButton : TPNumberPadButton
@end

@interface SBPasscodeNumberPadButton : TPNumberPadDarkStyleButton
@end
