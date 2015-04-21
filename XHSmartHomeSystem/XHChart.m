//
//  XHChart.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHChart.h"

@implementation XHChart

+ (void)drawLineWithContext:(CGContextRef)ctx startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor
{
    CGContextSetShouldAntialias(ctx, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(ctx, Linecolorspace1);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetStrokeColorWithColor(ctx, lineColor.CGColor);
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    CGContextStrokePath(ctx);
    CGColorSpaceRelease(Linecolorspace1);
}

@end
