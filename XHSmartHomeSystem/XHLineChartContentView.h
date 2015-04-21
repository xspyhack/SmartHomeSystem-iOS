//
//  XHLineChartContentView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/21/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHLineChartContentView : UIView

@property (nonatomic, assign) CGFloat inflexionPointWidth;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic) UIColor *y1LineColor;
@property (nonatomic) UIColor *y2LineColor;
@property (nonatomic, assign) CGFloat alpha;

@property (nonatomic, strong) NSArray *dataSource;

- (void)strokeChart;
- (void)refreshData:(NSArray *)dataSource;

@end
