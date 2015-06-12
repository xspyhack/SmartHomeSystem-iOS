//
//  XHDataAnalysisViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 5/4/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHDataAnalysisViewController.h"
#import "XHCircularView.h"
#import "XHColorTools.h"
#import "XHRoomTools.h"

#define WIDTH VIEW_WIDTH/5
#define HEIGHT WIDTH*3/2
#define PADDING ((VIEW_WIDTH-3*WIDTH)/4)
#define PADDING_TOP 50

@implementation XHDataAnalysisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Data Analysis", nil);
    [self setup];
}

- (void)setup
{
    NSArray *arrays = [XHRoomTools limitsDataWithRoomId:4];
    for (NSDictionary *dict in arrays) {
        [self setupDataViewWithValue:[dict[@"MIN(temperature)"] floatValue] sensor:0 limit:0];
        [self setupDataViewWithValue:[dict[@"AVG(temperature)"] floatValue] sensor:0 limit:1];
        [self setupDataViewWithValue:[dict[@"MAX(temperature)"] floatValue] sensor:0 limit:2];
        [self setupDataViewWithValue:[dict[@"MIN(humidity)"] floatValue] sensor:1 limit:0];
        [self setupDataViewWithValue:[dict[@"AVG(humidity)"] floatValue] sensor:1 limit:1];
        [self setupDataViewWithValue:[dict[@"MAX(humidity)"] floatValue] sensor:1 limit:2];
        [self setupDataViewWithValue:[dict[@"MIN(smoke)"] floatValue] sensor:2 limit:0];
        [self setupDataViewWithValue:[dict[@"AVG(smoke)"] floatValue] sensor:2 limit:1];
        [self setupDataViewWithValue:[dict[@"MAX(smoke)"] floatValue] sensor:2 limit:2];
    }
    
    CGRect frame = CGRectMake(0, VIEW_HEIGHT - 50, VIEW_WIDTH, 50);
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:frame];
    tipsLabel.text = NSLocalizedString(@"These data is from your house.", nil);
    tipsLabel.textColor = [XHColorTools themeColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipsLabel];
}

- (void)setupDataViewWithValue:(CGFloat)value sensor:(NSUInteger)sensorIndex limit:(NSUInteger)valueIndex
{
    UIColor *color = [UIColor clearColor];
    CGFloat max = -1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat padding_top = PADDING_TOP * (1 + sensorIndex) + HEIGHT * sensorIndex + 50;
    
    NSString *title = @"";
    switch (valueIndex) {
        case 0:
            title = NSLocalizedString(@"min", nil);
            break;
        case 1:
            title = NSLocalizedString(@"avg", nil);
            break;
        case 2:
            title = NSLocalizedString(@"max", nil);
            break;
        default:
            break;
    }
    
    switch (sensorIndex) {
        case 0:
            color = [XHColorTools temperatureColor];
            title = [title stringByAppendingString:@"(°C)"];
            max = [defaults floatForKey:@"XHTemperatureMaxValue"];
            break;
        case 1:
            color = [XHColorTools humidityColor];
            title = [title stringByAppendingString:@"(%RH)"];
            max = [defaults floatForKey:@"XHHumidityMaxValue"];
            break;
        case 2:
            color = [XHColorTools smokeColor];
            title = [title stringByAppendingString:@"(PPM)"];
            max = [defaults floatForKey:@"XHSmokeMaxValue"];
            break;
        default:
            break;
    }
    
    CGRect rect = CGRectMake(PADDING * (1 + valueIndex) + WIDTH * valueIndex, padding_top, WIDTH, HEIGHT);
    XHCircularView *view = [[XHCircularView alloc] initWithFrame:rect];
    view.progress = .7f;
    view.lineWidth = 5;
    view.value = value;
    view.title = title;
    view.color = color;
    
    [self.view addSubview:view];
    
}

@end
