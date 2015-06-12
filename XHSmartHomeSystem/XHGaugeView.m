//
//  XHGaugeView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHGaugeView.h"
#import <math.h>

@implementation Needle

- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    CATransform3D transform = layer.transform;
    
    layer.transform = CATransform3DIdentity;
    
    CGContextSetShouldAntialias(ctx, YES );
    CGContextSetFillColorWithColor(ctx, self.tintColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    CGContextSetLineWidth(ctx, self.width);
    
    CGFloat centerX = layer.frame.size.width / 2.0;
    CGFloat centerY = layer.frame.size.height / 2.0;
    
    CGFloat ellipseRadius = self.width * 2.0;
    
    CGContextFillEllipseInRect(ctx, CGRectMake(centerX - ellipseRadius, centerY - ellipseRadius, ellipseRadius * 2.0, ellipseRadius * 2.0));
    
    CGFloat endX = (1 + self.length) * centerX;
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, centerX, centerY);
    CGContextAddLineToPoint(ctx, endX, centerY);
    CGContextStrokePath(ctx);
    
    layer.transform = transform;
    
    CGContextRestoreGState(ctx);
}

@end

@interface XHGaugeView ()

@property (nonatomic, assign) float tickIncrement;
@property (nonatomic, assign) float minorTickIncrement;
@property (nonatomic, strong) UIFont *labelFont;

@end

@implementation XHGaugeView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int maxNumberOfTicks = (self.arcLength * self.frame.size.width) / (self.textLabel.font.pointSize * 10.0);
    
    float range = self.maxNumber - self.minNumber;
    
    float maxTickIncrement = range / maxNumberOfTicks;
    
    int power = 0;
    float temp = maxTickIncrement;
    
    while (temp >= 1.0) {
        temp = temp / 10.0;
        power++;
    }
    
    float exponent = pow(10, power);
    if (temp < 0.2) {
        self.tickIncrement = 0.1 * exponent;
        self.minorTickIncrement = self.tickIncrement / 5.0;
    } else if (temp < 0.5) {
        self.tickIncrement = 0.2 * pow(10, power);
        self.minorTickIncrement = self.tickIncrement / 4.0;
    } else if (temp < 1.0) {
        self.tickIncrement = 0.5 * pow(10, power);
        self.minorTickIncrement = self.tickIncrement / 5.0;
    } else {
        self.tickIncrement = 1.0 * pow(10, power);
        self.minorTickIncrement = self.tickIncrement / 5.0;
    }
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGFloat centerX = self.frame.size.width / 2.0;
    CGFloat centerY = self.frame.size.height / 2.0;
    CGFloat radius = fmin(self.frame.size.width, self.frame.size.height) / 2;
    
    int numberOfMinorTicks = (self.maxNumber - self.minNumber) / self.minorTickIncrement;
    
    CGPoint *points = (CGPoint*)malloc(sizeof(CGPoint) * (numberOfMinorTicks * 2 + 2));
    
    CGContextSetShouldAntialias(ctx, YES );
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextFillRect(ctx, layer.bounds);
    
    CGContextSetStrokeColorWithColor(ctx, _tintColor.CGColor);
    CGContextSetFillColorWithColor(ctx, _tintColor.CGColor);
    
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextBeginPath(ctx);
    
    CGContextSetTextDrawingMode(ctx, kCGTextFill);

    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(ctx, transform);
    UIGraphicsPushContext(ctx);
    
    float minorTickAngleIncrement = self.arcLength / (float)numberOfMinorTicks;
    
    float textHeight = self.textLabel.font.lineHeight;
    float textInset = textHeight + self.tickLength;
    
    float angle = self.startAngle;
    int i = 0;
    for (float f = self.minNumber; f <= self.maxNumber; f += self.minorTickIncrement) {
        points[i++] = CGPointMake(centerX + cos(angle) * (radius - self.tickInset), centerY + sin(angle) * (radius - self.tickInset));
        
        CGFloat myTickLength;
        
        if (fabs((f / self.tickIncrement - (int)(f / self.tickIncrement))) < 0.05) { // if is major tick
            myTickLength = self.tickLength;
            NSString *string = [[NSString alloc] initWithFormat:@"%1.0f", f];
            
            float textWidth = textHeight * [string length] / 2;
        
            CGPoint point = CGPointMake(centerX + cos(angle) * (radius - textInset) - textWidth / 2.0, centerY + sin(angle) * (radius - textInset) - textHeight / 2.0);
            [string drawAtPoint:point withAttributes:@{ NSFontAttributeName : self.textLabel.font,
                                                        NSForegroundColorAttributeName : _tintColor }];
        } else {
            myTickLength = self.minorTickLength;
        }
        
        points[i++] = CGPointMake(centerX + cos(angle) * (radius - myTickLength - self.tickInset), centerY + sin(angle) * (radius - myTickLength - self.tickInset));
        
        angle += minorTickAngleIncrement;
    }
    
    CGContextStrokeLineSegments(ctx, points, numberOfMinorTicks * 2 + 2);
    free(points);
    
    CGContextBeginPath(ctx);
    float epsilon = self.lineWidth / (radius * M_PI * 2);
    CGContextAddArc(ctx, centerX, centerY, radius - self.tickInset, self.startAngle - epsilon, self.startAngle + self.arcLength + epsilon, NO);
    CGContextStrokePath(ctx);
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect {
}

- (void)initialize {
    CGFloat span = fmin(self.frame.size.width, self.frame.size.height);

    
    _tintColor = [UIColor colorWithRed:0.7 green:1.0 blue:1.0 alpha:1.0];
    self.minNumber = 0.0;
    self.maxNumber = 100.0;
    self.startAngle = M_PI;
    self.arcLength = 3.0 * M_PI / 2.0;
    self.lineWidth = span / 200.0;
    self.tickLength = span / 12.0;
    self.minorTickLength = span / 16.0;
    self.tickInset = self.lineWidth;
    
    self.labelFont = [UIFont systemFontOfSize:span / 20.77];
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3.0 * self.frame.size.height / 10.0, self.frame.size.width, self.frame.size.height / 10.0)];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = self.labelFont;
    [self addSubview:self.textLabel];
    
    self.needle = [[Needle alloc] init];
    self.needle.tintColor = [UIColor orangeColor];
    self.needle.width = 2.0;
    self.needle.length = 0.8;
    
    self.needleLayer = [CALayer layer];
    self.needleLayer.bounds = self.bounds;
    self.needleLayer.position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    self.needleLayer.needsDisplayOnBoundsChange = YES;
    self.needleLayer.delegate = self.needle;
    
    [self.layer addSublayer:self.needleLayer];
    
    [self.needleLayer setNeedsDisplay];
}

- (void)setValue:(float)val {
    if (val > self.maxNumber)
        val = self.maxNumber;
    if (val < self.minNumber)
        val = self.minNumber;
    _value = val;
    
    // according valus to caculate move angle.
    CGFloat angle = self.startAngle + self.arcLength * val / (self.maxNumber - self.minNumber) - self.arcLength * (self.minNumber / (self.maxNumber - self.minNumber));
    
    self.needleLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

@end
