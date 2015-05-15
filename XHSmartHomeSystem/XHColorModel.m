//
//  XHColorModel.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/24/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHColorModel.h"

@implementation XHColorModel

+ (UIColor *)colorModelAtIndex:(NSInteger)index
{
    UIColor *color = [[UIColor alloc] init];
    switch (index) {
        case 0: color = XHPomegranateColor; break;
        case 1: color = XHAlizarinColor; break;
        case 2: color = XHPumpkinColor; break;
        case 3: color = XHCarrotColor; break;
        case 4: color = XHOrangeColor; break;
        case 5: color = XHSunFlowerColor; break;
        case 6: color = XHNephritisColor; break;
        case 7: color = XHEmeraldColor; break;
        case 8: color = XHGreenSeaColor; break;
        case 9: color = XHTurquoiseColor; break;
        case 10: color = XHBelizeColor; break;
        case 11: color = XHPeterRiverColor; break;
        case 12: color = XHWisteriaColor; break;
        case 13: color = XHAmethystColor; break;
        case 14: color = XHConcereteColor; break;
        case 15: color = XHSilverColor; break;
        case 16: color = XHConcereteColor; break;
        case 17: color = XHAsbestosColor; break;
        case 18: color = XHAsphaltColor; break;
        case 19: color = XHMidnightColor; break;
        default: color = XHColor; break;
    }
    
    return color;
}

@end
