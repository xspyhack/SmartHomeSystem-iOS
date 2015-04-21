//
//  XHGaugeView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Needle : NSObject

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) float length;
@property (nonatomic, assign) float width;

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx;

@end

@interface XHGaugeView : UIView

@property (nonatomic, assign) float minNumber;
@property (nonatomic, assign) float maxNumber;
@property (nonatomic, assign) double startAngle;
@property (nonatomic, assign) double arcLength;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) float tickInset;
@property (nonatomic, assign) float tickLength;

@property (nonatomic, assign) float minorTickLength;

@property (nonatomic, assign) float value;

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) Needle *needle;

@property (nonatomic, strong) CALayer *needleLayer;

-(void)initialize;

@end
