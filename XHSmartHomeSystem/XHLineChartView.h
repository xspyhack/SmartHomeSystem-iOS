//
//  XHLineChartView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHLineChartView : UIView

@property (nonatomic, assign) CGFloat inflexionPointWidth;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic) UIColor *y1LineColor;
@property (nonatomic) UIColor *y2LineColor;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, strong) NSArray *dataSource;

- (id)initWithFrame:(CGRect)frame xTitle:(NSString *)xTitle y1Title:(NSString *)y1Title y2Title:(NSString *)y2Title;
- (id)initWithFrame:(CGRect)frame xTitle:(NSString *)xTitle y1Title:(NSString *)y1Title y2Title:(NSString *)y2Title describe1:(NSString *)desc1 describe2:(NSString *)desc2;

- (void)strokeChartView;
- (void)refreshChartWithData:(NSArray*)dataSource;

@end
