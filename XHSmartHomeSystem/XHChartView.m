//
//  XHChartView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/17/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHChartView.h"
#import "XHLineChartItem.h"
#import "XHLineChartView.h"
#import "XHColorTools.h"
#import "XHRoomModel.h"
#import "XHRoomTools.h"

@interface XHChartView ()

@property (nonatomic, strong) UILabel *roomNameLabel;

@end

@implementation XHChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //do something here
        //[self setupDataSource];
        //[self setupChartView];
    }
    
    return self;
}

- (void)setupDataSource
{
    if (self.dataSource) {
        [self.dataSource removeAllObjects];
    }
    
    NSArray *array = [XHRoomTools recentWeekWithRoomId:self.roomId];
        
    for (int i = 0; i < 8; i++) {
        NSDictionary *dict = array[i];
        
        XHLineChartItem *item = [[XHLineChartItem alloc] init];

        item.xValue = i;
        item.y1Value = [dict[@"temperature"] floatValue];
        item.y2Value = [dict[@"humidity"] floatValue];
        
        [self.dataSource addObject:item];
    }
}

- (void)setupChartView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat lineWidth = [defaults floatForKey:@"XHLineWidth"];
    
    CGRect rect = CGRectMake(5, 30, self.frame.size.width - 10, 350);
    self.lineChartView = [[XHLineChartView alloc] initWithFrame:rect
                                                         xTitle:NSLocalizedString(@"date", nil)
                                                        y1Title:NSLocalizedString(@"temperature", nil)
                                                        y2Title:NSLocalizedString(@"humidity", nil)
                                                      describe1:NSLocalizedString(@"TEMP/°C", nil)
                                                      describe2:NSLocalizedString(@"HUMI/%RH", nil)];
    self.lineChartView.lineWidth = lineWidth;
    self.lineChartView.inflexionPointWidth = lineWidth * 3;
    self.lineChartView.y1LineColor = [XHColorTools temperatureColor];
    self.lineChartView.y2LineColor = [XHColorTools humidityColor];
    self.lineChartView.alpha = 1.f;
    self.lineChartView.dataSource = self.dataSource;
    
    [self.lineChartView strokeChartView];
    [self addSubview:self.lineChartView];
    
    CGRect roomRect = CGRectMake(10, CGRectGetMaxY(rect), self.frame.size.width - 20, 50);
    self.roomNameLabel = [[UILabel alloc] initWithFrame:roomRect];
    self.roomNameLabel.textAlignment = NSTextAlignmentCenter;
    self.roomNameLabel.textColor = [XHColorTools themeColor];
    [self addSubview:self.roomNameLabel];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setRoomId:(NSInteger)roomId
{
    _roomId = roomId;
    [self setupDataSource];
    [self setupChartView];
    
    if (roomId == XHParlour) {
        self.roomNameLabel.text = NSLocalizedString(@"Parlour", nil);
    } else if (roomId == XHBedroom) {
        self.roomNameLabel.text = NSLocalizedString(@"Bedroom", nil);
    } else if (roomId == XHKitchen) {
        self.roomNameLabel.text = NSLocalizedString(@"Kitchen", nil);
    } else if (roomId == XHBathroom) {
        self.roomNameLabel.text = NSLocalizedString(@"Bathroom", nil);
    }
}

/*
 - (void)setDataSource:(NSMutableArray *)dataSource
 {
 
 }
 */

@end
