//
//  UIBarButtonItem+Extension.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/15/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highLightedImageName:(NSString *)highLightedImageName target:(id)target action:(SEL)action;

@end
