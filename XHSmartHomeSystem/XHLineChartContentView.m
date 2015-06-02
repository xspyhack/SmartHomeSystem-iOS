//
//  XHLineChartContentView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHLineChartContentView.h"
#import "XHChart.h"
#import "XHLineChartItem.h"

#define DEFAULT_Y_COUNT 5 // y axis count
#define DEFAULT_X_COUNT 7 // x axis count

@interface XHLineChartContentView ()

@property (nonatomic) NSMutableArray *chartLineArray;  // Array[CAShapeLayer]
@property (nonatomic) NSMutableArray *chartPointArray; // Array[CAShapeLayer] save the point layer

@property (nonatomic) NSMutableArray *chartPath;       // Array of line path, one for each line.
@property (nonatomic) NSMutableArray *pointPath;

@property (nonatomic) NSMutableArray *pathPoints;

@property (strong, nonatomic) NSMutableArray *xArray; // x step
@property (strong, nonatomic) NSMutableArray *y1Array; // y1 step
@property (strong, nonatomic) NSMutableArray *y2Array; // y2 step

@property CGFloat xPerValue;
@property NSInteger currXStepCount;
@property NSInteger currYStepCount;

@property CGPoint originPoint;
@property CGPoint leftTopPoint;
@property CGPoint rightBottomPoint;

@property CGFloat marginLeft;
@property CGFloat marginRight;
@property CGFloat marginBottom;
@property int maxHeight;
@property int maxWidth;
@property CGPoint contentScroll;

@property CGFloat xPerStepWidth;
@property CGFloat yPerStepHeight;


@end

@implementation XHLineChartContentView

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // initialization here
        [self setupDefaultValues];
    }
    return self;
}

#pragma mark - interface method

- (void)strokeChart
{
    self.chartPath = [[NSMutableArray alloc] init];
    self.pointPath = [[NSMutableArray alloc] init];
    
    [self calculateChartPath:self.chartPath pointsPath:self.pointPath pathKeyPoints:self.pathPoints];
    
    // Draw each lines
    for (NSUInteger i = 0; i < 2; i++) {
        CAShapeLayer *chartLine = (CAShapeLayer *)self.chartLineArray[i];
        CAShapeLayer *pointLayer = (CAShapeLayer *)self.chartPointArray[i];
        UIGraphicsBeginImageContext(self.frame.size);
        UIBezierPath *progressLine = [self.chartPath objectAtIndex:i];
        UIBezierPath *pointPath = [self.pointPath objectAtIndex:i];
        
        chartLine.path = progressLine.CGPath;
        pointLayer.path = pointPath.CGPath;
        
        [CATransaction begin];
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        
        [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        chartLine.strokeEnd = 1.0;
        
        // if you want cancel the point animation, conment this code, the point will show immediately
        [pointLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        [CATransaction commit];
        
        UIGraphicsEndImageContext();
    }
}

- (void)refreshData:(NSArray*)dataSource
{
    self.dataSource = dataSource;
    
    [self buildXYStepArray:DEFAULT_X_COUNT yStepCount:DEFAULT_Y_COUNT];    
    [self prepareXYLabels];
    
    [self calculateChartPath:self.chartPath pointsPath:self.pointPath pathKeyPoints:self.pathPoints];
    
    // Draw each line
    for (NSUInteger i = 0; i < 2; i++) {
        CAShapeLayer *chartLine = (CAShapeLayer *)self.chartLineArray[i];
        CAShapeLayer *pointLayer = (CAShapeLayer *)self.chartPointArray[i];

        UIBezierPath *progressLine = [self.chartPath objectAtIndex:i];
        UIBezierPath *pointPath = [self.pointPath objectAtIndex:i];
        
        CABasicAnimation * pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.fromValue = (id)chartLine.path;
        pathAnimation.toValue = (id)[progressLine CGPath];
        pathAnimation.duration = 0.5f;
        pathAnimation.autoreverses = NO;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [chartLine addAnimation:pathAnimation forKey:@"animationKey"];
        
        
        CABasicAnimation * pointPathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pointPathAnimation.fromValue = (id)pointLayer.path;
        pointPathAnimation.toValue = (id)[pointPath CGPath];
        pointPathAnimation.duration = 0.5f;
        pointPathAnimation.autoreverses = NO;
        pointPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [pointLayer addAnimation:pointPathAnimation forKey:@"animationKey"];
        
        chartLine.path = progressLine.CGPath;
        pointLayer.path = pointPath.CGPath;
    }
}

#pragma mark - setters

- (void)setInflexionPointWidth:(CGFloat)inflexionPointWidth
{
    _inflexionPointWidth = inflexionPointWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
}

- (void)setY1LineColor:(UIColor *)y1LineColor
{
    _y1LineColor = y1LineColor;
}

- (void)setY2LineColor:(UIColor *)y2LineColor
{
    _y2LineColor = y2LineColor;
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
}

- (void)setDataSource:(NSArray *)dataSource
{
    if (dataSource != _dataSource) {
        // remove all shape layers before adding new ones
        for (CALayer *layer in self.chartLineArray) {
            [layer removeFromSuperlayer];
        }
        for (CALayer *layer in self.chartPointArray) {
            [layer removeFromSuperlayer];
        }
        
        self.chartLineArray = [NSMutableArray arrayWithCapacity:2];
        self.chartPointArray = [NSMutableArray arrayWithCapacity:2];
        
        [self addLineLayerWithColor:self.y1LineColor];
        [self addLineLayerWithColor:self.y2LineColor];
        [self addPointLayerWithColor:self.y1LineColor isFillColor:NO];
        [self addPointLayerWithColor:self.y2LineColor isFillColor:YES];
        
        _dataSource = dataSource;
        
        [self buildXYStepArray:DEFAULT_X_COUNT yStepCount:DEFAULT_Y_COUNT];
        self.currXStepCount = DEFAULT_X_COUNT;
        self.currYStepCount = DEFAULT_Y_COUNT;
        
        [self prepareXYLabels];

        [self setNeedsDisplay];
    }
}

#pragma mark - setup

- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = YES;
    self.chartLineArray = [NSMutableArray new];
    self.pathPoints = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;
    
    self.marginLeft = 40;
    self.marginRight = 40;
    
    self.lineWidth = 1.f;
    self.inflexionPointWidth = 4.f;
    self.y1LineColor = XHY1LineColor;
    self.y2LineColor = XHY2LineColor;
    self.alpha = 1.f;
}

- (void)addLineLayerWithColor:(UIColor *)color
{
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineCap = kCALineCapButt;
    lineLayer.lineJoin = kCALineJoinMiter;
    lineLayer.strokeColor = [[color colorWithAlphaComponent:self.alpha ] CGColor];
    lineLayer.lineWidth = self.lineWidth;
    lineLayer.strokeEnd = 0.0;
    [self.layer addSublayer:lineLayer];
    [self.chartLineArray addObject:lineLayer];
}

- (void)addPointLayerWithColor:(UIColor *)color isFillColor:(BOOL)isFillColor
{
    CAShapeLayer *pointLayer = [CAShapeLayer layer];
    pointLayer.strokeColor = [[color colorWithAlphaComponent:self.alpha] CGColor];
    pointLayer.lineCap = kCALineCapRound;
    pointLayer.lineJoin = kCALineJoinBevel;
    if (isFillColor) {
        pointLayer.fillColor = [color CGColor];
        [pointLayer fillColor];
    } else {
        pointLayer.fillColor = nil;
    }
    pointLayer.lineWidth = self.lineWidth;
    [self.layer addSublayer:pointLayer];
    [self.chartPointArray addObject:pointLayer];
}

// create x, y1, y2 step array
- (void)buildXYStepArray:(NSInteger)xStepCount yStepCount:(NSInteger)yStepCount
{
    if (self.dataSource.count >= 2) {
        float xMin, xMax, y1Min, y1Max, y2Min, y2Max;
        XHLineChartItem *item = [self.dataSource objectAtIndex:0];
        xMin = item.xValue; xMax = item.xValue;
        y1Min = item.y1Value; y1Max = item.y1Value;
        y2Min = item.y2Value; y2Max = item.y2Value;
        
        for (NSInteger i = 1; i < self.dataSource.count; i++) {
            XHLineChartItem *item = [self.dataSource objectAtIndex:i];
            if (item.xValue < xMin)
                xMin = item.xValue;
            else if (item.xValue > xMax)
                xMax = item.xValue;
            
            if (item.y1Value < y1Min)
                y1Min = item.y1Value;
            else if (item.y1Value > y1Max)
                y1Max = item.y1Value;
            
            if (item.y2Value < y2Min)
                y2Min = item.y2Value;
            else if (item.y2Value > y2Max)
                y2Max = item.y2Value;
        }
        
        // x axis
        if (!self.xArray)
            self.xArray = [NSMutableArray array];
        else
            [self.xArray removeAllObjects];
        float xPer = (xMax ) / xStepCount ;
        self.xPerValue = xPer;
        for (int i=0; i<xStepCount; i++) {
            [self.xArray addObject:[NSNumber numberWithFloat: (xPer + i * xPer)]];
        }
        
        // left y axis
        if (!self.y1Array)
            self.y1Array = [NSMutableArray array];
        else
            [self.y1Array removeAllObjects];
        float y1Per = (y1Max ) / yStepCount ;
        for (int i=0; i<yStepCount; i++) {
            [self.y1Array addObject:[NSNumber numberWithFloat: (y1Per + i * y1Per)]];
        }
        
        // right y axis
        if (!self.y2Array)
            self.y2Array = [NSMutableArray array];
        else
            [self.y2Array removeAllObjects];
        float y2Per = (y2Max ) / yStepCount ;
        for (int i = 0; i<yStepCount; i++) {
            [self.y2Array addObject:[NSNumber numberWithFloat: (y2Per + i * y2Per)]];
        }
    }
    else if (self.dataSource.count == 1) {
        XHLineChartItem *item = [self.dataSource objectAtIndex:0];
        //
        NSNumber *num1 = [NSNumber numberWithDouble:item.xValue];
        self.xArray = [NSMutableArray arrayWithObject:num1];
        //
        NSNumber *num2 = [NSNumber numberWithDouble:item.y1Value];
        self.y1Array = [NSMutableArray arrayWithObject:num2];
        //
        NSNumber *num3 = [NSNumber numberWithDouble:item.y2Value];
        self.y2Array = [NSMutableArray arrayWithObject:num3];
    }
    [self setNeedsDisplay];
}

#pragma mark - private methods

- (void)calculateChartPath:(NSMutableArray *)chartPath pointsPath:(NSMutableArray *)pointsPath pathKeyPoints:(NSMutableArray *)pathPoints
{
    UIBezierPath *progressLine1 = [UIBezierPath bezierPath];
    UIBezierPath *progressLine2 = [UIBezierPath bezierPath];
    
    UIBezierPath *pointPath1 = [UIBezierPath bezierPath];
    UIBezierPath *pointPath2 = [UIBezierPath bezierPath];
    
    
    [chartPath insertObject:progressLine1 atIndex:0];
    [pointsPath insertObject:pointPath1 atIndex:0];
    
    [chartPath insertObject:progressLine2 atIndex:1];
    [pointsPath insertObject:pointPath2 atIndex:1];
    
    NSMutableArray *line1PointsArray = [[NSMutableArray alloc] init];
    NSMutableArray *line2PointsArray = [[NSMutableArray alloc] init];
    
    float last_xPos = 0;
    float last_yPos1 = 0;
    float last_yPos2 = 0;
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        XHLineChartItem *item = (XHLineChartItem *)[self.dataSource objectAtIndex:i];
        
        float xPerStepVal = [(NSNumber*)[self.xArray objectAtIndex:0] floatValue];
        float xPosition = self.originPoint.x + ((self.xPerStepWidth * item.xValue) / xPerStepVal) + self.contentScroll.x;
        
        float y1PerStepVal = [(NSNumber*)[self.y1Array objectAtIndex:0] floatValue];
        float y1Position = self.originPoint.y - fabs(((self.yPerStepHeight * item.y1Value) / y1PerStepVal)) + self.contentScroll.y;
        
        float y2PerStepVal = [(NSNumber*)[self.y2Array objectAtIndex:0] floatValue];
        float y2Position = self.originPoint.y - fabs(((self.yPerStepHeight * item.y2Value) / y2PerStepVal)) + self.contentScroll.y;
        
        CGRect circleRect1 = CGRectMake(xPosition - self.inflexionPointWidth/2,
                                        y1Position - self.inflexionPointWidth/2,
                                        self.inflexionPointWidth,
                                        self.inflexionPointWidth);
        
        CGPoint circleCenter1 = CGPointMake(circleRect1.origin.x + (circleRect1.size.width/2),
                                            circleRect1.origin.y + (circleRect1.size.height/2));
        
        [pointPath1 moveToPoint:CGPointMake(circleCenter1.x + (self.inflexionPointWidth/2),
                                            circleCenter1.y)];
        
        [pointPath1 addArcWithCenter:circleCenter1
                               radius:self.inflexionPointWidth/2
                          startAngle:0
                            endAngle:2 * M_PI
                           clockwise:YES];
        
        CGRect circleRect2 = CGRectMake(xPosition-self.inflexionPointWidth/2,
                                        y2Position-self.inflexionPointWidth/2,
                                        self.inflexionPointWidth,
                                        self.inflexionPointWidth);
        CGPoint circleCenter2 = CGPointMake(circleRect2.origin.x + (circleRect2.size.width/2),
                                            circleRect2.origin.y + (circleRect2.size.height/2));
        
        [pointPath2 moveToPoint:CGPointMake(circleCenter2.x + (self.inflexionPointWidth/2),
                                            circleCenter2.y)];
        
        [pointPath2 addArcWithCenter:circleCenter2
                              radius:self.inflexionPointWidth/2
                          startAngle:0
                            endAngle:2 * M_PI
                           clockwise:YES];
        
        
        if ( i != 0 ) {
            // calculate the point of line
            float distance1 = sqrt(pow(xPosition - last_xPos, 2) + pow(y1Position - last_yPos1, 2));
            float last_x = last_xPos + (self.inflexionPointWidth/2) / distance1 * (xPosition - last_xPos);
            float last_y1 = last_yPos1 + (self.inflexionPointWidth/2) / distance1 * (y1Position - last_yPos1);
            float x = xPosition - (self.inflexionPointWidth/2) / distance1 * (xPosition - last_xPos);
            float y1 = y1Position - (self.inflexionPointWidth/2) / distance1 * (y1Position - last_yPos1);
            
            [progressLine1 moveToPoint:CGPointMake(last_x, last_y1)];
            [progressLine1 addLineToPoint:CGPointMake(x, y1)];
            
            float distance2 = sqrt(pow(xPosition - last_xPos, 2) + pow(y2Position - last_yPos2, 2));
            float last_y2 = last_yPos2 + (self.inflexionPointWidth/2) / distance2 * (y2Position - last_yPos2);
            
            float y2 = y2Position - (self.inflexionPointWidth/2) / distance2 * (y2Position - last_yPos2);
            
            [progressLine2 moveToPoint:CGPointMake(last_x, last_y2)];
            [progressLine2 addLineToPoint:CGPointMake(x, y2)];
            
        }
        last_xPos = xPosition;
        last_yPos1 = y1Position;
        last_yPos2 = y2Position;
        [line1PointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, y1Position)]];
        [line2PointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(xPosition, y2Position)]];
    }
    
    [pathPoints addObject:[line1PointsArray copy]];
    [pathPoints addObject:[line2PointsArray copy]];
    
}

#pragma mark draw coordinate axis

-(void)prepareXYLabels
{
    UIFont *xyTextFont = [UIFont systemFontOfSize:8];
    
    // get max value format to string
    double xMax =  [[self.xArray objectAtIndex:0] integerValue];
    for (NSNumber *num in self.xArray) {
        if ([num doubleValue] > xMax) {
            xMax = [num doubleValue];
        }
    }
    NSString *xMaxStr = [NSString stringWithFormat:@"%.2lf", xMax];
    CGSize size = [xMaxStr sizeWithAttributes:@{NSFontAttributeName:xyTextFont}];
    self.marginBottom = size.height;
    
    //
    double y1Max =  [[self.y1Array objectAtIndex:0] integerValue];
    for (NSNumber *num in self.y1Array) {
        if ([num doubleValue] > y1Max) {
            y1Max = [num doubleValue];
        }
    }
    NSString *y1MaxStr = [NSString stringWithFormat:@"%.2lf", y1Max];
    size = [y1MaxStr sizeWithAttributes:@{NSFontAttributeName:xyTextFont}];
    self.marginLeft = size.width;
    //
    double y2Max =  [[self.y2Array objectAtIndex:0] integerValue];
    for (NSNumber *num in self.y2Array) {
        if ([num doubleValue] > y2Max) {
            y2Max = [num doubleValue];
        }
    }
    NSString *y2MaxStr = [NSString stringWithFormat:@"%.2lf", y2Max];
    size = [y2MaxStr sizeWithAttributes:@{NSFontAttributeName:xyTextFont}];
    self.marginRight = size.width;
    
    //
    self.originPoint = CGPointMake(self.marginLeft+2, self.frame.size.height - self.marginBottom-20);
    self.leftTopPoint = CGPointMake(self.originPoint.x, 0+20);
    self.rightBottomPoint = CGPointMake(self.frame.size.width - self.marginRight-2, self.originPoint.y);
    
    //
    self.xPerStepWidth = (self.rightBottomPoint.x - self.originPoint.x) / (DEFAULT_X_COUNT)-0.1;
    self.maxWidth = (self.xArray.count-1) * self.xPerStepWidth;
    
    self.yPerStepHeight = (self.originPoint.y - self.leftTopPoint.y) / (DEFAULT_Y_COUNT)-0.1;
    //
    NSInteger yStepCount = (self.y1Array.count > self.y2Array.count ? self.y1Array.count : self.y2Array.count);
    self.maxHeight = (yStepCount-1) * self.yPerStepHeight;
    
}

- (void)drawXYLabels
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIFont *xyTextFont = [UIFont systemFontOfSize:8];
    UIColor *xyTextColor = [UIColor lightGrayColor];
    UIColor *dataLineColor = [UIColor lightGrayColor];
    
    NSUInteger today = [[NSDate alloc] weekdayIndex]; // 1 < today < 7
   
    // x axis
    for (NSInteger index = 0; index < self.xArray.count; index++) {
        
        NSUInteger weekday = (today + index) % 7;
        NSString *valStr = [self weekdayWithIndex:weekday];
        if (index == self.xArray.count - 1) {
            valStr = NSLocalizedString(@"Today", nil);
        }
        //NSNumber *num = [self.xArray objectAtIndex:index];
        //NSString *valStr = [NSString stringWithFormat:@"%.3lf", [num doubleValue]];
        
        float xPosition = self.originPoint.x + (index+1)* self.xPerStepWidth + self.contentScroll.x;
        
        if (xPosition > self.originPoint.x && xPosition < self.rightBottomPoint.x) {
            
            // draw x axis label text
            [xyTextColor set];
            CGSize title1Size = [valStr sizeWithAttributes:@{ NSFontAttributeName:xyTextFont }];
            CGRect titleRect1 = CGRectMake(xPosition - (title1Size.width)/2,
                                           self.originPoint.y+2,
                                           title1Size.width,
                                           title1Size.height);
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.alignment = NSTextAlignmentCenter;
            [valStr drawInRect:titleRect1 withAttributes:@{ NSFontAttributeName:xyTextFont,
                                                            NSForegroundColorAttributeName:xyTextColor,
                                                            NSParagraphStyleAttributeName:paragraph }];
            

            CGFloat dashPattern[]= { 6.0, 5 };
            if (index < self.xArray.count-1) {
                CGContextSetLineDash(context, 0.0, dashPattern, 2); // dash line
                [XHChart drawLineWithContext:context
                                 startPoint:CGPointMake(xPosition, self.originPoint.y)
                                   endPoint:CGPointMake(xPosition, self.leftTopPoint.y)
                                  lineColor:dataLineColor];
            }
        }
    }
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentRight;
    
    // y1 axis
    for (NSInteger i = 0; i < self.y1Array.count; i++) {
        NSNumber *num = [self.y1Array objectAtIndex:i];
        NSString *valStr = [NSString stringWithFormat:@"%.2lf", [num doubleValue]];
        
        CGFloat y1Position = self.originPoint.y - (i+1) * self.yPerStepHeight + self.contentScroll.y; // - (textSize.height/2);
        
        if (y1Position < self.originPoint.y && y1Position > self.leftTopPoint.y) {
    
            [self.y1LineColor set];
            CGSize title1Size = [valStr sizeWithAttributes:@{ NSFontAttributeName:xyTextFont }];
            CGRect titleRect1 = CGRectMake(1,
                                           y1Position - (title1Size.height)/2,
                                           title1Size.width,
                                           title1Size.height);
            [valStr drawInRect:titleRect1 withAttributes:@{ NSFontAttributeName:xyTextFont,
                                                            NSForegroundColorAttributeName:self.y1LineColor,
                                                            NSParagraphStyleAttributeName:paragraph}];
            
            CGFloat dashPattern[]= { 6.0, 5 };
            CGContextSetLineDash(context, 0.0, dashPattern, 2);
            [XHChart drawLineWithContext:context
                             startPoint:CGPointMake(self.originPoint.x, y1Position)
                               endPoint:CGPointMake(self.rightBottomPoint.x, y1Position)
                              lineColor:dataLineColor];
        }
    }
    
    // y2 axis
    for (NSInteger i = 0; i < self.y2Array.count; i++) {
        NSNumber *num = [self.y2Array objectAtIndex:i];
        NSString *valStr = [NSString stringWithFormat:@"%.2lf", [num doubleValue]];
        
        CGFloat y2Position = self.originPoint.y - (i+1) * self.yPerStepHeight + self.contentScroll.y; // - (textSize.height/2);
        
        if (y2Position < self.originPoint.y && y2Position > self.leftTopPoint.y) {
            
            [self.y2LineColor set];
            CGSize title1Size = [valStr sizeWithAttributes:@{ NSFontAttributeName:xyTextFont }];
            CGRect titleRect1 = CGRectMake(self.rightBottomPoint.x+1,
                                           y2Position - (title1Size.height)/2,
                                           title1Size.width,
                                           title1Size.height);
            [valStr drawInRect:titleRect1 withAttributes:@{ NSFontAttributeName:xyTextFont,
                                                            NSForegroundColorAttributeName:self.y2LineColor,
                                                            NSParagraphStyleAttributeName:paragraph }];
            
            CGFloat dashPattern[]= { 6.0, 5 };
            CGContextSetLineDash(context, 0.0, dashPattern, 2);
            [XHChart drawLineWithContext:context
                             startPoint:CGPointMake(self.originPoint.x, y2Position)
                               endPoint:CGPointMake(self.rightBottomPoint.x, y2Position)
                              lineColor:dataLineColor];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawXYLabels];
    UIColor *dataLineColor = [UIColor lightGrayColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // y1 axis
    CGFloat normal[1] = { 1 };
    CGContextSetLineDash(context, 0, normal, 0);
    [XHChart drawLineWithContext:context
                     startPoint:self.originPoint
                       endPoint:CGPointMake(self.leftTopPoint.x, self.leftTopPoint.y-20)
                      lineColor:dataLineColor];
    // draw left y axis arrow
    CGContextMoveToPoint(context, self.leftTopPoint.x-3, self.leftTopPoint.y-17);
    CGContextAddLineToPoint(context, self.leftTopPoint.x, self.leftTopPoint.y-20);
    CGContextAddLineToPoint(context, self.leftTopPoint.x+3, self.leftTopPoint.y-17);
    CGContextStrokePath(context);
    
    // y2 axis
    [XHChart drawLineWithContext:context
                     startPoint:self.rightBottomPoint
                       endPoint:CGPointMake(self.rightBottomPoint.x, self.leftTopPoint.y-20)
                      lineColor:dataLineColor];
    
    // draw right y axis arrow
    CGContextMoveToPoint(context, self.rightBottomPoint.x-3, self.leftTopPoint.y-17);
    CGContextAddLineToPoint(context, self.rightBottomPoint.x, self.leftTopPoint.y-20);
    CGContextAddLineToPoint(context, self.rightBottomPoint.x+3, self.leftTopPoint.y-17);
    CGContextStrokePath(context);
    
    // x axis
    [XHChart drawLineWithContext:context
                     startPoint:CGPointMake(self.originPoint.x, self.originPoint.y)
                       endPoint:CGPointMake(self.rightBottomPoint.x, self.rightBottomPoint.y)
                      lineColor:dataLineColor];
    
    [super drawRect:rect];
}

- (NSString *)weekdayWithIndex:(NSUInteger)index
{
    NSString *weekday = @"";
    switch (index) {
        case 0:
            weekday = NSLocalizedString(@"Sun", nil);
            break;
        case 1:
            weekday = NSLocalizedString(@"Mon", nil);
            break;
        case 2:
            weekday = NSLocalizedString(@"Tue", nil);
            break;
        case 3:
            weekday = NSLocalizedString(@"Wed", nil);
            break;
        case 4:
            weekday = NSLocalizedString(@"Thu", nil);
            break;
        case 5:
            weekday = NSLocalizedString(@"Fri", nil);
            break;
        case 6:
            weekday = NSLocalizedString(@"Sat", nil);
            break;
        default:
            break;
    }
    return weekday;
}

@end
