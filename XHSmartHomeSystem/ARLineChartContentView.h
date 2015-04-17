//
//  SportLineChartContentView.h
//  testLineChart
//
//  Created by LongJun on 13-12-21.
//  Copyright (c) 2013年 LongJun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLineChartView.h"

@interface ARLineChartContentView : UIView

//构造函数，必须使用
- (id)initWithFrame:(CGRect)frame dataSource:(NSArray*)dataSource;

//刷新图表
- (void)refreshData:(NSArray*)dataSource;

@end
