//
//  XHChart.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ChartViewMargin_Top 20
#define Y1_Margin_Left 20
#define Y2_Margin_Right 20
#define X_Margin_Bottom 20
#define xTitleFontSize 12
#define descFontSize 8

#define XHY1LineColor [UIColor colorWithRed:(float)249/255 green:(float)176/255 blue:(float)47/255 alpha:1.0]
#define XHY2LineColor [UIColor colorWithRed:(float)73/255 green:(float)146/255 blue:(float)187/255 alpha:1.0]

@interface XHChart : NSObject

+ (void)drawLineWithContext:(CGContextRef)ctx startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor;

@end
