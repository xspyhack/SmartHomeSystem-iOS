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

#define XHColorsViewHeight 370
typedef enum {
    EMChartModeSwitch = 0,
    EMGaugeModeSwitch = 1
}EMSwitch;

@interface XHDisplayViewController ()
@property (nonatomic, strong) XHLineView *lineView;
@property (nonatomic, strong) XHColorsView *colorsView;
@property (nonatomic, assign) BOOL chartSwitch; // chart mode switch is on or close
@property (nonatomic, assign) BOOL gaugeSwitch; // gauge mode switch's status
@end

@implementation XHDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLineView];
    [self setupColorsView];
    [self setupModeGroup];
    [self setupBrushGroup];
}

#pragma mark - setup methods

- (void)setupLineView
{
    CGRect rect = CGRectMake(0, -XHColorsViewHeight, self.view.frame.size.width, XHColorsViewHeight);
    self.lineView = [[XHLineView alloc] initWithFrame:rect];
    self.lineView.pull = YES;
    
    [self.view addSubview:self.lineView];
}

- (void)setupColorsView
{
    CGRect rect = CGRectMake(0, -XHColorsViewHeight, self.view.frame.size.width, XHColorsViewHeight);
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
    self.chartSwitch = [defaults boolForKey:@"ChartModeSwitch"];
    self.gaugeSwitch = [defaults boolForKey:@"GaugeModeSwitch"];
    
    XHTableViewCellSwitchItem *chartItem = [XHTableViewCellSwitchItem itemWithTitle:@"Line chart mode"];
    chartItem.on = self.chartSwitch;
    chartItem.tapSwitch = ^ {
        [self setSwitch:EMChartModeSwitch];
    };
    
    XHTableViewCellSwitchItem *gaugeItem = [XHTableViewCellSwitchItem itemWithTitle:@"Gauge mode"];
    gaugeItem.on = self.gaugeSwitch;
    gaugeItem.tapSwitch = ^ {
        [self setSwitch:EMGaugeModeSwitch];
    };
    
    group.items = @[chartItem, gaugeItem];
}

- (void)setupBrushGroup
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CGFloat lineWidth = [defaults floatForKey:@"XHLineWidth"];
    
    XHTableViewCellGroup *group = [XHTableViewCellGroup group];
    [self.groups addObject:group];
    
    XHTableViewCellArrowItem *lineWidthItem = [XHTableViewCellArrowItem itemWithTitle:@"Line width"];
    lineWidthItem.detail = [NSString stringWithFormat:@"%.2f", lineWidth];
    lineWidthItem.operation = ^ {
        [self.lineView pullDown:0.5f];
    };
    
    XHTableViewCellArrowItem *tempColorItem = [XHTableViewCellArrowItem itemWithTitle:@"Temperature color"];
    tempColorItem.operation = ^ {
        self.colorsView.master = @"XHTemperatureColor";
        [self.colorsView pullDown:0.5f];
    };
    
    XHTableViewCellArrowItem *humiColorItem = [XHTableViewCellArrowItem itemWithTitle:@"Humidity color"];
    humiColorItem.operation = ^ {
        self.colorsView.master = @"XHHumidityColor";
        [self.colorsView pullDown:0.5f];
    };
    
    XHTableViewCellArrowItem *smokeColorItem = [XHTableViewCellArrowItem itemWithTitle:@"Smoke color"];
    smokeColorItem.operation = ^ {
        self.colorsView.master = @"XHSmokeColor";
        [self.colorsView pullDown:0.5f];
    };
    
    group.items = @[lineWidthItem, tempColorItem, humiColorItem, smokeColorItem];
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

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.chartSwitch forKey:@"ChartModeSwitch"];
    [defaults setBool:self.gaugeSwitch forKey:@"GaugeModeSwitch"];
}

/*
- (void)dismissSubview
{
    [self.colorsView pullUp];
}

- (void)moveColorsView
{
    NSTimeInterval animationDuration = 0.5f;
    [UIView beginAnimations:@"MoveLogoView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.colorsView.frame = CGRectMake(0, 133.5, self.colorsView.frame.size.width, XHColorsViewHeight);
    //self.colorsView.center = self.view.center;
    
    [UIView commitAnimations];
}
 */

@end
