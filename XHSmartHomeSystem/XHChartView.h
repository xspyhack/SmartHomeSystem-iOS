//
//  XHChartView.h
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/17/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XHLineChartView;

@interface XHChartView : UIView

@property (nonatomic, strong) XHLineChartView *lineChartView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic) NSInteger roomId;

@end
