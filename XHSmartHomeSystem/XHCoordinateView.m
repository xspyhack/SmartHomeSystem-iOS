//
//  XHCoordinateView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/16/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHCoordinateView.h"
#import "XHChart.h"
#import "XHColorTools.h"

@implementation XHCoordinateView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat xFix = (width - 160)/4;
    CGFloat yFix = (height - 60)/4;
    
    CGRect parlousRect = CGRectMake(width/2+xFix, yFix, 80, 30);
    UILabel *parlous = [[UILabel alloc] initWithFrame:parlousRect];
    parlous.text = NSLocalizedString(@"Parlour", nil);
    parlous.font = [UIFont systemFontOfSize:13];
    parlous.textColor = [XHColorTools themeColor];
    parlous.textAlignment = NSTextAlignmentCenter;
    
    CGRect kitchenRect = CGRectMake(xFix, yFix, 80, 30);
    UILabel *kitchen = [[UILabel alloc] initWithFrame:kitchenRect];
    kitchen.text = NSLocalizedString(@"Kitchen", nil);
    kitchen.font = [UIFont systemFontOfSize:13];
    kitchen.textColor = [XHColorTools themeColor];
    kitchen.textAlignment = NSTextAlignmentCenter;
    
    CGRect bathroomRect = CGRectMake(xFix, height/2+yFix, 80, 30);
    UILabel *bathroom = [[UILabel alloc] initWithFrame:bathroomRect];
    bathroom.text = NSLocalizedString(@"Bathroom", nil);
    bathroom.font = [UIFont systemFontOfSize:13];
    bathroom.textColor = [XHColorTools themeColor];
    bathroom.textAlignment = NSTextAlignmentCenter;
    
    CGRect bedroomRect = CGRectMake(width/2+xFix, height/2+yFix, 80, 30);
    UILabel *bedroom = [[UILabel alloc] initWithFrame:bedroomRect];
    bedroom.text = NSLocalizedString(@"Bedroom", nil);
    bedroom.font = [UIFont systemFontOfSize:13];
    bedroom.textColor = [XHColorTools themeColor];
    bedroom.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:parlous];
    [self addSubview:kitchen];
    [self addSubview:bathroom];
    [self addSubview:bedroom];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // draw coordinate axis
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // x axis
    CGPoint xStartPoint = CGPointMake(0, self.bounds.size.height/2);
    CGPoint xEndPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height/2);
    CGFloat normal[1] = { 1 };
    CGContextSetLineDash(context, 0, normal, 0);
    [XHChart drawLineWithContext:context
                      startPoint:xStartPoint
                        endPoint:xEndPoint
                       lineColor:[UIColor blackColor]];
    
    // y axis
    CGPoint yStartPoint = CGPointMake(self.bounds.size.width/2, 0);
    CGPoint yEndPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
    CGContextSetLineDash(context, 0, normal, 0);
    [XHChart drawLineWithContext:context
                      startPoint:yStartPoint
                        endPoint:yEndPoint
                       lineColor:[UIColor blackColor]];
    
    [super drawRect:rect];

}

@end
