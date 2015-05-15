//
//  XHLineChartView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHLineChartView.h"
#import "XHLineChartContentView.h"
#import "XHChart.h"
#import "XHColorTools.h"

@interface XHLineChartView ()

@property (strong, nonatomic) NSString *y1Title;
@property (strong, nonatomic) NSString *y2Title;
@property (strong, nonatomic) NSString *xTitle;
@property (strong, nonatomic) NSString *desc1;
@property (strong, nonatomic) NSString *desc2;
@property (strong, nonatomic) XHLineChartContentView *lineChartContentView;

@end

@implementation XHLineChartView

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // initialization code
        [self setupDefaultValues];
        [self setChartView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame xTitle:(NSString *)xTitle y1Title:(NSString *)y1Title y2Title:(NSString *)y2Title
{
    if (self = [super initWithFrame:frame]) {
        // initialization code
        [self setupDefaultValues];
        self.backgroundColor = [UIColor clearColor];
        
        self.xTitle = xTitle ? xTitle : @"X";
        self.y1Title = y1Title ? y1Title : @"Y1";
        self.y2Title = y2Title ? y2Title : @"Y2";
        
        self.desc1 = @"DESC1";
        self.desc2 = @"DESC2";
        
        [self setChartView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame xTitle:(NSString *)xTitle y1Title:(NSString *)y1Title y2Title:(NSString *)y2Title describe1:(NSString *)desc1 describe2:(NSString *)desc2
{
    if (self = [super initWithFrame:frame]) {
        // initialization code
        [self setupDefaultValues];
        self.backgroundColor = [UIColor clearColor];
        
        self.xTitle = xTitle ? xTitle : @"X";
        self.y1Title = y1Title ? y1Title : @"Y1";
        self.y2Title = y2Title ? y2Title : @"Y2";
        
        self.desc1 = desc1 ? desc1 : @"DESC1";
        self.desc2 = desc2 ? desc2 : @"DESC2";
        
        [self setChartView];
    }
    return self;
}

#pragma mark - interface methods

- (void)strokeChartView
{
    [self.lineChartContentView strokeChart];
}

- (void)refreshChartWithData:(NSArray *)dataSource
{
    [self.lineChartContentView refreshData:dataSource];
}

#pragma mark - setters

- (void)setInflexionPointWidth:(CGFloat)inflexionPointWidth
{
    _inflexionPointWidth = inflexionPointWidth;
    self.lineChartContentView.inflexionPointWidth = inflexionPointWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if (lineWidth < 1) {
        lineWidth = 1;
    }
    _lineWidth = lineWidth;
    self.lineChartContentView.lineWidth = lineWidth;
}

- (void)setY1LineColor:(UIColor *)y1LineColor
{
    _y1LineColor = y1LineColor;
    self.lineChartContentView.y1LineColor = y1LineColor;
}

- (void)setY2LineColor:(UIColor *)y2LineColor
{
    _y2LineColor = y2LineColor;
    self.lineChartContentView.y2LineColor = y2LineColor;
}

- (void)setAlpha:(CGFloat)alpha
{
    _alpha = alpha;
    self.lineChartContentView.alpha = alpha;
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    self.lineChartContentView.dataSource = dataSource;
}

#pragma mark - private methods

- (void)setupDefaultValues
{
    self.backgroundColor = [UIColor whiteColor];
    self.xTitle = @"X";
    self.y1Title = @"Y1";
    self.y2Title = @"Y2";
    self.desc1 = @"DESC1";
    self.desc2 = @"DESC2";
    self.y1LineColor = XHY1LineColor;
    self.y2LineColor = XHY2LineColor;
}

- (void)setChartView
{
    UIFont *font = [UIFont systemFontOfSize:14];
    CGFloat y = ChartViewMargin_Top;
    
    CGSize y1TtleSize = [self.y1Title sizeWithAttributes:@{ NSFontAttributeName : font }];
    CGRect y1TitleRect = CGRectMake(Y1_Margin_Left - 10,
                                    y,
                                    y1TtleSize.width,
                                    y1TtleSize.height);
    UILabel *y1TitleLabel = [[UILabel alloc] initWithFrame:y1TitleRect];
    y1TitleLabel.text = self.y1Title;
    y1TitleLabel.textColor = [XHColorTools temperatureColor];
    y1TitleLabel.font = font;
    [self addSubview:y1TitleLabel];
    
    //
    y = y1TitleRect.origin.y;
    CGSize y2TitleSize = [self.y2Title sizeWithAttributes:@{ NSFontAttributeName : font }];
    CGRect y2TitleRect = CGRectMake(self.frame.size.width - y2TitleSize.width - Y2_Margin_Right + 10,
                                    y,
                                    y2TitleSize.width,
                                    y2TitleSize.height);
    UILabel *y2TitleLabel = [[UILabel alloc] initWithFrame:y2TitleRect];
    y2TitleLabel.text = self.y2Title;
    y2TitleLabel.textColor = [XHColorTools humidityColor];
    y2TitleLabel.font = font;
    [self addSubview:y2TitleLabel];
    
    y = CGRectGetMaxY(y2TitleRect) + 2;
    CGRect rect = CGRectMake(0,
                             y,
                             self.frame.size.width,
                             self.frame.size.height - y - X_Margin_Bottom);
    self.lineChartContentView = [[XHLineChartContentView alloc] initWithFrame:rect];
    
    [self addSubview:self.lineChartContentView];

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // describe 1
    UIColor *textColor = self.y1LineColor;
    [textColor set];
    CGFloat originY =  self.frame.size.height - X_Margin_Bottom;
    CGFloat y = originY + (X_Margin_Bottom/2);
    CGPoint startPoint = CGPointMake(Y1_Margin_Left, y);
    CGPoint endPoint = CGPointMake(Y1_Margin_Left + 15, y);
    [XHChart drawLineWithContext:context startPoint:startPoint endPoint:endPoint lineColor:textColor];

    UIFont *descFont = [UIFont systemFontOfSize:descFontSize];
    CGSize desc1Size = [self.desc1 sizeWithAttributes:@{ NSFontAttributeName : descFont }];
    CGRect desc1Rect = CGRectMake(endPoint.x + 3,
                                  y - (desc1Size.height/2),
                                  desc1Size.width,
                                  desc1Size.height);
    
    //
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    
    [self.desc1 drawInRect:desc1Rect withAttributes:@{ NSFontAttributeName : descFont,
                                                       NSForegroundColorAttributeName : self.y1LineColor,
                                                       NSParagraphStyleAttributeName : paragraph }];
    
    // describe 2
    textColor = self.y2LineColor;
    [textColor set];
    
    startPoint = CGPointMake(desc1Rect.origin.x + desc1Rect.size.width + 10, y);
    endPoint = CGPointMake(startPoint.x + 15, y);
    [XHChart drawLineWithContext:context startPoint:startPoint endPoint:endPoint lineColor:textColor];

    CGSize desc2Size = [self.desc2 sizeWithAttributes:@{ NSFontAttributeName : descFont }];
    CGRect desc2Rect = CGRectMake(endPoint.x + 3,
                                  y - (desc2Size.height/2),
                                  desc2Size.width,
                                  desc2Size.height);
    [self.desc2 drawInRect:desc2Rect withAttributes:@{ NSFontAttributeName : descFont,
                                                       NSForegroundColorAttributeName : self.y2LineColor,
                                                       NSParagraphStyleAttributeName : paragraph }];
    // x axis describe
    [[UIColor grayColor] set];
    UIFont *titleXFont = [UIFont systemFontOfSize:xTitleFontSize];
    CGSize titleXSize = [self.xTitle sizeWithAttributes:@{ NSFontAttributeName : titleXFont }];
    CGRect titleXRect = CGRectMake((self.frame.size.width - titleXSize.width) / 2,
                                   y - (titleXSize.height/2) - 15,
                                   titleXSize.width,
                                   titleXSize.height);
    
    NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.alignment = NSTextAlignmentCenter;
    
    [self.xTitle drawInRect:titleXRect withAttributes:@{ NSFontAttributeName : titleXFont,
                                                         NSForegroundColorAttributeName : [XHColorTools themeColor],
                                                         NSParagraphStyleAttributeName : paragraph2 }];
}

@end
