//
//  ControlCenter.h
//  HoYosphere
//
//  Created by Alexandra Aurora Göttlicher
//

#import "Common.h"

static UIImage* resizedImageWithName(NSString* name);

NSDictionary* colors;

NSUserDefaults* preferences;
BOOL pfEnabled;
NSString* pfStyle;

@interface CCUIRoundButton : UIControl
@property(nonatomic)UIImage* glyphImage;
@property(nonatomic)UIView* selectedStateBackgroundView;
- (UIViewController *)_viewControllerForAncestor;
@end

@interface CCUICAPackageDescription : NSObject
@property(nonatomic, copy, readonly)NSURL* packageURL;
+ (CCUICAPackageDescription *)initWithPackageName:(NSString *)name inBundle:(NSBundle *)bundle;
@end
