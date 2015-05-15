//
//  XHDisplayViewController.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/23/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHDisplayViewController.h"
#import "XHTableViewCellGroup.h"
#import "XHTableViewCellSwitchItem.h"
#import "XHTableViewCellArrowItem.h"
#import "XHLineView.h"
#import "XHColorsView.h"
#import "XHValueViewController.h"

#define XHColorsViewHeight (self.view.frame.size.width + 10)
typedef enum _EMSwitch {
    EMChartModeSwitch = 0,
    EMGaugeModeSwitch = 1
} EMSwitch;

@interface XHDisplayViewController ()
@property (nonatomic, strong) XHTableViewCellArrowItem *tempRangeItem;
@property (nonatomic, strong) XHTableViewCellArrowItem *humiRangeItem;
@property (nonatomic, strong) XHTableViewCellArrowItem *smokeRangeItem;
@property (nonatomic, strong) XHLineView *lineView;
@property (nonatomic, strong) XHColorsView *colorsView;
@property (nonatomic, assign) BOOL chartSwitch; // chart mode switch is on or close
@property (nonatomic, assign) BOOL gaugeSwitch; // gauge mode switch's status
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, copy) NSString *tempRange;
@property (nonatomic, copy) NSString *humiRange;
@property (nonatomic, copy) NSString *smokeRange;
@end

@implementation XHDisplayViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLineView];
    [self setupColorsView];
    [self setupModeGroup];
    [self setupBrushGroup];
    [self setupRangeGroup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserDefaults];
    self.tempRangeItem.detail = self.tempRange;
    self.humiRangeItem.detail = self.humiRange;
    self.smokeRangeItem.detail = self.smokeRange;
    [self.tableView reloadData]; // update cell
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.chartSwitch forKey:@"XHChartModeSwitch"];
    [defaults setBool:self.gaugeSwitch forKey:@"XHGaugeModeSwitch"];
}

#pragma mark - setup methods

- (void)setupLineView
{
    CGRect rect = CGRectMake(0, -XHColorsViewHeight - 66, self.view.frame.size.width, XHColorsViewHeight);
    self.lineView = [[XHLineView alloc] initWithFrame:rect];
    self.lineView.pull = YES;
    [self.view addSubview:self.lineView];
}

- (void)setupColorsView
{
    CGRect rect = CGRectMake(0, -XHColorsViewHeight - 66, self.view.frame.size.width, XHColorsViewHeight);
    self.colorsView = [[XHColorsView alloc] initWithFrame:rect];
    self.colorsView.pull = YES;
    [self.view addSubview:self.colorsView];
}

- (void)setupModeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    // read user defaults settings
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.chartSwitch = [defaults boolForKey:@"XHChartModeSwitch"];
    self.gaugeSwitch = [defaults boolForKey:@"XHGaugeModeSwitch"];
    
    XHTableViewCellSwitchItem *chartItem = [XHTableViewCellSwitchItem itemWithTitle:@"Line chart mode"];
    chartItem.on = self.chartSwitch;
    chartItem.tapSwitch = ^{ [self setSwitch:EMChartModeSwitch]; };
    
    XHTableViewCellSwitchItem *gaugeItem = [XHTableViewCellSwitchItem itemWithTitle:@"Gauge mode"];
    gaugeItem.on = self.gaugeSwitch;
    gaugeItem.tapSwitch = ^{ [self setSwitch:EMGaugeModeSwitch]; };
    
    group.items = @[chartItem, gaugeItem];
}

- (void)setupBrushGroup
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.lineWidth = [defaults floatForKey:@"XHLineWidth"];
    
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *lineWidthItem = [XHTableViewCellArrowItem itemWithTitle:@"Line width"];
    lineWidthItem.detail = [NSString stringWithFormat:@"%.2f", self.lineWidth];
    lineWidthItem.clicked = ^{ [self.lineView pullDown:0.5f]; };
    
    XHTableViewCellArrowItem *tempColorItem = [XHTableViewCellArrowItem itemWithTitle:@"Temperature color"];
    tempColorItem.clicked = ^{
        self.colorsView.master = @"XHTemperatureColor";
        [self.colorsView pullDown:0.5f];
    };
    
    XHTableViewCellArrowItem *humiColorItem = [XHTableViewCellArrowItem itemWithTitle:@"Humidity color"];
    humiColorItem.clicked = ^{
        self.colorsView.master = @"XHHumidityColor";
        [self.colorsView pullDown:0.5f];
    };
    
    XHTableViewCellArrowItem *smokeColorItem = [XHTableViewCellArrowItem itemWithTitle:@"Smoke color"];
    smokeColorItem.clicked = ^{
        self.colorsView.master = @"XHSmokeColor";
        [self.colorsView pullDown:0.5f];
    };
    
    group.groupHeader = @"Brush";
    group.items = @[ lineWidthItem, tempColorItem, humiColorItem, smokeColorItem ];
}

- (void)setupRangeGroup
{
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    [self getUserDefaults];
    
    self.tempRangeItem = [XHTableViewCellArrowItem itemWithTitle:@"Temperature"];
    self.tempRangeItem.detail = self.tempRange;
    self.tempRangeItem.destinationContorller = [XHValueViewController class];
    
    self.humiRangeItem = [XHTableViewCellArrowItem itemWithTitle:@"Humidity"];
    self.humiRangeItem.detail = self.humiRange;
    self.humiRangeItem.destinationContorller = [XHValueViewController class];
    
    self.smokeRangeItem = [XHTableViewCellArrowItem itemWithTitle:@"Smoke"];
    self.smokeRangeItem.detail = self.smokeRange;
    self.smokeRangeItem.destinationContorller = [XHValueViewController class];
    
    group.groupHeader = @"Range";
    group.groupFooter = @"Setup max or min value which will show in line chart or gauge chart can help system more accurately to show data.";
    group.items = @[ self.tempRangeItem, self.humiRangeItem, self.smokeRangeItem ];
}

#pragma mark - private methods

- (void)setSwitch:(NSInteger)index
{
    switch (index) {
        case EMChartModeSwitch:
            self.chartSwitch = !self.chartSwitch;
            break;
        case EMGaugeModeSwitch:
            self.gaugeSwitch = !self.gaugeSwitch;
            break;
        default:
            break;
    }
}

- (void)getUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.tempRange = [NSString stringWithFormat:@"%.1f - %.1f",
                      [defaults floatForKey:@"XHTemperatureMinValue"],
                      [defaults floatForKey:@"XHTemperatureMaxValue"]];
    
    self.humiRange = [NSString stringWithFormat:@"%.1f - %.1f",
                      [defaults floatForKey:@"XHHumidityMinValue"],
                      [defaults floatForKey:@"XHHumidityMaxValue"]];
    
    self.smokeRange = [NSString stringWithFormat:@"%.1f - %.1f",
                       [defaults floatForKey:@"XHSmokeMinValue"],
                       [defaults floatForKey:@"XHSmokeMaxValue"]];
}

/*
- (void)dismissSubview
{
    [self.colorsView pullUp];
}
*/

@end
