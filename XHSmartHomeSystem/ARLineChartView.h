//
//  RLLineChartView.h
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARLineChartView : UIView


//构造函数，必须使用
- (id)initWithFrame:(CGRect)frame dataSource:(NSArray*)dataSource xTitle:(NSString*)xTitle y1Title:(NSString*)y1Title y2Title:(NSString*)y2Title desc1:(NSString*)desc1 desc2:(NSString*)desc2;

//刷新图表
- (void)refreshData:(NSArray*)dataSource;

@end
