//
//  XHStatusBarTipsWindow.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 6/1/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHStatusBarTipsWindow : UIWindow

+ (XHStatusBarTipsWindow *)shareTipsWindow;

- (void)showTips:(NSString *)tips;
- (void)showTips:(NSString *)tips hideAfterDelay:(NSInteger)seconds;

- (void)hideTips;

@end
