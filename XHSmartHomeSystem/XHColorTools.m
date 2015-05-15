//
//  XHColorTools.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/25/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHColorTools.h"
#import "XHColorModel.h"

@implementation XHColorTools

+ (UIColor *)themeColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [XHColorModel colorModelAtIndex:[defaults integerForKey:@"XHThemeColor"]];
}

+ (UIColor *)textColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [XHColorModel colorModelAtIndex:[defaults integerForKey:@"XHTextColor"]];
}

+ (UIColor *)defaultColor
{
    return XHColor;
}

+ (UIColor *)temperatureColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [XHColorModel colorModelAtIndex:[defaults integerForKey:@"XHTemperatureColor"]];
}

+ (UIColor *)humidityColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [XHColorModel colorModelAtIndex:[defaults integerForKey:@"XHHumidityColor"]];
}

+ (UIColor *)smokeColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [XHColorModel colorModelAtIndex:[defaults integerForKey:@"XHSmokeColor"]];
}

@end
