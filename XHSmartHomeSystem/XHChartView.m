//
//  XHChartView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/17/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHChartView.h"
#import "ARLineChartCommon.h"
#import "ARLineChartView.h"
#import "XHRoomModel.h"

@interface XHChartView ()

@property (nonatomic, strong) UILabel *roomNameLabel;

@end

typedef enum {
    XHParlour = 0,
    XHBedroom = 1,
    XHKitchen = 2,
    XHBathroom = 3
}XHRoomId;

@implementation XHChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //do something here
        [self setupDataSource];
        [self setupChartView];
    }
    
    return self;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/*
- (void)setDataSource:(NSMutableArray *)dataSource
{
    
}
*/

- (void)setupDataSource
{
    double distanceMin = 0, distanceMax = 100;
    double altitudeMin = 5.0, altitudeMax = 50;
    double speedMin = 0.5, speedMax = 15;
    
    srand(time(NULL)); //Random seed
    for (int i = 0; i < 8; i++) {
        //srand(time(i)); //Random seed
        RLLineChartItem *item = [[RLLineChartItem alloc] init];
        double randVal;
        
        randVal = rand() /((double)(RAND_MAX)/distanceMax) + distanceMin;
        item.xValue = i;
        
        randVal = rand() /((double)(RAND_MAX)/altitudeMax) + altitudeMin;
        item.y1Value = randVal;
        
        randVal = rand() /((double)(RAND_MAX)/speedMax) + speedMin;
        item.y2Value = randVal;
        
        NSLog(@"Random: item.xValue=%.2lf, item.y1Value=%.2lf, item.y2Value=%.2lf", item.xValue, item.y1Value, item.y2Value);
        [self.dataSource addObject:item];
    }
}

- (void)setRoomId:(NSInteger)roomId
{
    _roomId = roomId;
    if (roomId == XHParlour) {
        _roomNameLabel.text = @"parlour";
    } else if (roomId == XHBedroom) {
        _roomNameLabel.text = @"bedroom";
    } else if (roomId == XHKitchen) {
        _roomNameLabel.text = @"kitchen";
    } else if (roomId == XHBathroom) {
        _roomNameLabel.text = @"bathroom";
    }
}

- (void)setupChartView
{
    CGRect rect = CGRectMake(5, 30, self.frame.size.width - 10, 350);
    self.lineChartView = [[ARLineChartView alloc] initWithFrame:rect dataSource:self.dataSource xTitle:@"date" y1Title:@"temperature" y2Title:@"humidity" desc1:@"TEMP" desc2:@"HUMI"];
    [self addSubview:self.lineChartView];
    
    CGRect roomRect = CGRectMake(10, CGRectGetMaxY(rect), self.frame.size.width, 100);
    _roomNameLabel = [[UILabel alloc] initWithFrame:roomRect];
    _roomNameLabel.textAlignment = NSTextAlignmentCenter;
    _roomNameLabel.textColor = XHOrangeColor;
    [self addSubview:_roomNameLabel];
}

@end
