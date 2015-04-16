//
//  UIBarButtonItem+Extension.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/15/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

#define XHBtnWidthAndHeight 30

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highLightedImageName:(NSString *)highLightedImageName target:(id)target action:(SEL)action
{
    // custom UIView
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highLightedImageName] forState:UIControlStateHighlighted];
    
    // set frame
    [btn setFrame:CGRectMake(0, 2, XHBtnWidthAndHeight, XHBtnWidthAndHeight)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
