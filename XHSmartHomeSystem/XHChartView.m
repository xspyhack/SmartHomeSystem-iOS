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
#import "XHRoomModel.h"
#import "XHColorTools.h"

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
    if (self.dataSource) {
        [self.dataSource removeAllObjects];
    }
    srand(time(NULL)); //Random seed
    for (int i = 0; i < 8; i++) {
        //srand(time(i)); //Random seed
        XHLineChartItem *item = [[XHLineChartItem alloc] init];
        double randVal;
        
        randVal = rand() /((double)(RAND_MAX)/distanceMax) + distanceMin;
        item.xValue = i;
        
        randVal = rand() /((double)(RAND_MAX)/altitudeMax) + altitudeMin;
        item.y1Value = randVal;
        
        randVal = rand() /((double)(RAND_MAX)/speedMax) + speedMin;
        item.y2Value = randVal;
        
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat lineWidth = [defaults floatForKey:@"LineWidth"];
    //NSInteger tempIndex = [defaults integerForKey:@"TempColor"];
    //NSInteger humiIndex = [defaults integerForKey:@"HumiColor"];
    //UIColor *tempColor = [XHColorModel colorModelWithIndex:tempIndex];
    //UIColor *humiColor = [XHColorModel colorModelWithIndex:humiIndex];
    
    CGRect rect = CGRectMake(5, 30, self.frame.size.width - 10, 350);
    self.lineChartView = [[XHLineChartView alloc] initWithFrame:rect xTitle:@"date" y1Title:@"temperature" y2Title:@"humidity" describe1:@"TEMP" describe2:@"HUMI"];
    self.lineChartView.lineWidth = lineWidth;
    self.lineChartView.inflexionPointWidth = 3.f;
    self.lineChartView.y1LineColor = [XHColorTools temperatureColor];
    self.lineChartView.y2LineColor = [XHColorTools humidityColor];
    self.lineChartView.alpha = 1.f;
    self.lineChartView.dataSource = self.dataSource;
    
    [self.lineChartView strokeChartView];
    [self addSubview:self.lineChartView];
    
    CGRect roomRect = CGRectMake(10, CGRectGetMaxY(rect), self.frame.size.width - 20, 100);
    _roomNameLabel = [[UILabel alloc] initWithFrame:roomRect];
    _roomNameLabel.textAlignment = NSTextAlignmentCenter;
    _roomNameLabel.textColor = [XHColorTools themeColor];
    [self addSubview:_roomNameLabel];
    
    UIButton *refresh = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(roomRect), self.frame.size.width - 20, 30)];
    [refresh setTitle:@"refresh" forState:UIControlStateNormal];
    refresh.backgroundColor = [XHColorTools themeColor];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refresh];
}

- (void)refresh
{
    [self setupDataSource];
    [self.lineChartView refreshChartWithData:self.dataSource];
}

@end
