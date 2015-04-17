//
//  RLLineChartView.m
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//
#if !__has_feature(objc_arc)
#error "This source file must be compiled with ARC enabled!"
#endif

#import "ARLineChartView.h"
#import "ARLineChartContentView.h"
#import "ARLineChartCommon.h"


#define MARGIN_TOP 20
#define Y1_MARGIN_LEFT 20
#define Y2_MARGIN_RIGHT 20
#define X_MARGIN_BUTTOM 20 //x轴横线距离底边的高度
#define titleXFontSize 12
#define descFontSize 8

@interface ARLineChartView ()

@property (strong, nonatomic) NSString *title1;
@property (strong, nonatomic) NSString *title2;
@property (strong, nonatomic) NSString *titleX;
@property (strong, nonatomic) NSString *desc1;
@property (strong, nonatomic) NSString *desc2;

@property (strong, nonatomic) ARLineChartContentView *lineChartContentView;

@end

@implementation ARLineChartView

- (id)initWithFrame:(CGRect)frame dataSource:(NSArray*)dataSource xTitle:(NSString*)xTitle y1Title:(NSString*)y1Title y2Title:(NSString*)y2Title desc1:(NSString*)desc1 desc2:(NSString*)desc2
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        //////////// test ///////////////////
        self.titleX = xTitle ? xTitle : @"X";
        self.title1 = y1Title ? y1Title : @"Y1";
        self.title2 = y2Title ? y2Title : @"Y2";
        
        self.desc1 = desc1 ? desc1 : @"Desc1";
        self.desc2 = desc2 ? desc2 : @"Desc2";
        //////////// end //////////////////
        
        ////////////////////////// 上面的标题 //////////////////////////
        UIFont *font = [UIFont systemFontOfSize:14];
        CGFloat y = MARGIN_TOP;
        
        CGSize title1Size = [y1Title sizeWithAttributes:@{NSFontAttributeName:font}];
        CGRect titleRect1 = CGRectMake(Y1_MARGIN_LEFT - 10,
                                       y,
                                       title1Size.width,
                                       title1Size.height);
        UILabel *lblTitle1 = [[UILabel alloc] initWithFrame:titleRect1];
        lblTitle1.text = y1Title;
        lblTitle1.textColor = line1Color;
        lblTitle1.font = font;
        [self addSubview:lblTitle1];
        
        //
        y = titleRect1.origin.y;
        CGSize title2Size = [y2Title sizeWithAttributes:@{NSFontAttributeName:font}];
        CGRect titleRect2 = CGRectMake(self.frame.size.width - title2Size.width - Y2_MARGIN_RIGHT + 10,
                                       y,
                                       title2Size.width,
                                       title2Size.height);
        UILabel *lblTitle2 = [[UILabel alloc] initWithFrame:titleRect2];
        lblTitle2.text = y2Title;
        lblTitle2.textColor = line2Color;
        lblTitle2.font = font;
        [self addSubview:lblTitle2];
        
        
        ////////////////////// 折线图内容区域 ///////////////////////////
        y = titleRect2.origin.y + titleRect2.size.height + 2;
        CGRect rect = CGRectMake(0,
                                 y,
                                 self.frame.size.width,
                                 self.frame.size.height - y - X_MARGIN_BUTTOM);
        self.lineChartContentView = [[ARLineChartContentView alloc] initWithFrame:rect dataSource:dataSource];
        [self addSubview:self.lineChartContentView];
        
        
        ////////////////////// 注册手势监听 ///////////////////////////
        //UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
        //                                                                              action:@selector(pinchDetected:)];
        
        //[self addGestureRecognizer:pinchRecognizer];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    ////////////////////// 画底部线条颜色说明文字 //////////////////////////
    //短线条1
    UIColor *textColor = line1Color;
    [textColor set];
    CGFloat originY =  self.frame.size.height - X_MARGIN_BUTTOM;
    CGFloat y = originY + (X_MARGIN_BUTTOM/2);
    CGPoint startPoint = CGPointMake(Y1_MARGIN_LEFT, y);
    CGPoint endPoint = CGPointMake(Y1_MARGIN_LEFT + 15, y);
    [ARLineChartCommon drawLine:context startPoint:startPoint endPoint:endPoint lineColor:textColor];
    //描述文字1
    UIFont *descFont = [UIFont systemFontOfSize:descFontSize];
    CGSize desc1Size = [self.desc1 sizeWithAttributes:@{NSFontAttributeName:descFont}];
    CGRect desc1Rect = CGRectMake(endPoint.x + 3,
                                  y - (desc1Size.height/2),
                                  desc1Size.width,
                                  desc1Size.height);
    
    //
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    
    [self.desc1 drawInRect:desc1Rect withAttributes:@{NSFontAttributeName:descFont,
                                                       NSForegroundColorAttributeName:line1Color,
                                                       NSParagraphStyleAttributeName:paragraph}];
    
    //短线条2
    textColor = line2Color;
    [textColor set];
    
    startPoint = CGPointMake(desc1Rect.origin.x + desc1Rect.size.width + 10, y);
    endPoint = CGPointMake(startPoint.x + 15, y);
    [ARLineChartCommon drawLine:context startPoint:startPoint endPoint:endPoint lineColor:textColor];
    //描述文字2
    CGSize desc2Size = [self.desc2 sizeWithAttributes:@{NSFontAttributeName:descFont}];
    CGRect desc2Rect = CGRectMake(endPoint.x + 3,
                                  y - (desc2Size.height/2),
                                  desc2Size.width,
                                  desc2Size.height);
    [self.desc2 drawInRect:desc2Rect withAttributes:@{NSFontAttributeName:descFont,
                                                      NSForegroundColorAttributeName:line2Color,
                                                      NSParagraphStyleAttributeName:paragraph}];
    //x轴说明文字
    [[UIColor grayColor] set];
    UIFont *titleXFont = [UIFont systemFontOfSize:titleXFontSize];
    CGSize titleXSize = [self.title1 sizeWithAttributes:@{NSFontAttributeName:titleXFont}];
    CGRect titleXRect = CGRectMake((self.frame.size.width - titleXSize.width) / 2,
                                   y - (titleXSize.height/2) - 15,
                                   titleXSize.width,
                                   titleXSize.height);
    
    NSMutableParagraphStyle *paragraph2 = [[NSMutableParagraphStyle alloc] init];
    paragraph2.alignment = NSTextAlignmentCenter;
    
    [self.titleX drawInRect:titleXRect withAttributes:@{NSFontAttributeName:titleXFont,
                                                        NSForegroundColorAttributeName:XHOrangeColor,
                                                        NSParagraphStyleAttributeName:paragraph2}];
    
}

//刷新图表
- (void)refreshData:(NSArray*)dataSource
{
    [self.lineChartContentView refreshData:dataSource];
}

@end




